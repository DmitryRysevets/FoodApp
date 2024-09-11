//
//  NetworkManager.swift
//  FoodApp
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

enum NetworkLayerError: Error {
    case parseDataFailed
    case downloadImageFailed(Error)
    case uploadImageFailed(Error)
    case firestoreDataWasNotReceived(Error)
    case firestoreDataWasNotSaved(Error)
    case invalidData
    case networkError(Error)
    case authenticationFailed
    case userAlreadyExists
    case userNotFound
    case updateFailed(Error)
}

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    private let auth = Auth.auth()
    
    func downloadImage(from storageURL: String) async throws -> Data {
        let imageStorageReference = storage.reference(forURL: storageURL)
        let maxImageSize: Int64 = 3 * 1024 * 1024 // 3MB

        return try await withCheckedThrowingContinuation { continuation in
            imageStorageReference.getData(maxSize: maxImageSize) { data, error in
                if let error = error {
                    continuation.resume(throwing: NetworkLayerError.downloadImageFailed(error))
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    fatalError("\(#function) Unexpected: Both data and error are nil")
                }
            }
        }
    }
    
    func sendFeedback(message: String) async throws {
        let userID: String
        if let currentUser = auth.currentUser {
            userID = currentUser.uid
        } else {
            userID = "guest"
        }
        
        let documentID = UUID().uuidString
        let feedbackDocument = firestore.collection("feedbacks").document(documentID)
        
        let feedbackData: [String: Any] = [
            "user": userID,
            "message": message,
            "date": Timestamp(date: Date())
        ]
        
        do {
            try await feedbackDocument.setData(feedbackData)
        } catch {
            throw NetworkLayerError.firestoreDataWasNotSaved(error)
        }
    }
    
    // MARK: - Menu methods

    func getMenu() async throws -> Menu {
        let offersData = try await getFirestoreData("offers")
        let dishesData = try await getFirestoreData("menu")

        var offers: [Offer] = []
        var dishes: [Dish] = []
        
        try await withThrowingTaskGroup(of: Offer.self) { taskGroup in
            for offerData in offersData {
                taskGroup.addTask {
                    return try await self.createOffer(from: offerData)
                }
            }
            for try await offer in taskGroup {
                offers.append(offer)
            }
        }
        
        try await withThrowingTaskGroup(of: Dish.self) { taskGroup in
            for dishData in dishesData {
                taskGroup.addTask {
                    return try await self.createDish(from: dishData)
                }
            }
            for try await dish in taskGroup {
                dishes.append(dish)
            }
        }

        return Menu(offers: offers, dishes: dishes)
    }
    
    func getLatestMenuVersionNumber() async throws -> String {
        let documents = try await getFirestoreData("versions")
                
        guard let document = documents.first(where: { $0.documentID == "latest" }),
              let data = document.data(),
              let version = data["menu"] as? String
        else {
            throw NetworkLayerError.invalidData
        }
        
        return version
    }
    
    // MARK: - User methods

    func authenticateUser(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            auth.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    if (error as NSError).code == AuthErrorCode.networkError.rawValue {
                        continuation.resume(throwing: NetworkLayerError.networkError(error))
                    } else {
                        continuation.resume(throwing: NetworkLayerError.authenticationFailed)
                    }
                    return
                }
                guard let user = authResult?.user else {
                    continuation.resume(throwing: NetworkLayerError.authenticationFailed)
                    return
                }
                continuation.resume(returning: user)
            }
        }
    }

    func registerUser(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            auth.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    if (error as NSError).code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        continuation.resume(throwing: NetworkLayerError.userAlreadyExists)
                    } else if (error as NSError).code == AuthErrorCode.networkError.rawValue {
                        continuation.resume(throwing: NetworkLayerError.networkError(error))
                    } else {
                        continuation.resume(throwing: NetworkLayerError.authenticationFailed)
                    }
                    return
                }
                guard let user = authResult?.user else {
                    continuation.resume(throwing: NetworkLayerError.authenticationFailed)
                    return
                }
                continuation.resume(returning: user)
            }
        }
    }
    
    func setDisplayName(_ name: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NetworkLayerError.userNotFound
        }
        
        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = name
        
        do {
            try await changeRequest.commitChanges()
        } catch {
            throw NetworkLayerError.updateFailed(error)
        }
    }
    
    func updateEmail(to newEmail: String, withPassword password: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NetworkLayerError.userNotFound
        }
        
        let credential = EmailAuthProvider.credential(withEmail: currentUser.email ?? "", password: password)
        
        do {
            try await currentUser.reauthenticate(with: credential)
            try await currentUser.sendEmailVerification(beforeUpdatingEmail: newEmail)
            
        } catch {
            throw NetworkLayerError.updateFailed(error)
        }
    }
    
    func updatePassword(currentPassword: String, to newPassword: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NetworkLayerError.userNotFound
        }

        let credential = EmailAuthProvider.credential(withEmail: currentUser.email ?? "", password: currentPassword)

        do {
            try await currentUser.reauthenticate(with: credential)
            try await currentUser.updatePassword(to: newPassword)
        } catch {
            throw NetworkLayerError.updateFailed(error)
        }
    }
    
    func uploadUserAvatar(_ avatarData: Data) async throws -> URL {
        guard let currentUser = Auth.auth().currentUser else {
            throw NetworkLayerError.userNotFound
        }

        let storageRef = storage.reference().child("userAvatars/\(currentUser.uid)/avatar.jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            let _ = try await storageRef.putDataAsync(avatarData, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            
            let changeRequest = currentUser.createProfileChangeRequest()
            changeRequest.photoURL = downloadURL
            
            try await changeRequest.commitChanges()
            
            return downloadURL
        } catch {
            throw NetworkLayerError.uploadImageFailed(error)
        }
    }

    
    func deleteUserAvatar() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NetworkLayerError.userNotFound
        }
        
        let avatarRef = storage.reference().child("userAvatars/\(currentUser.uid)/avatar.jpg")
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            avatarRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // MARK: - Order methods
    
    func saveOrderToFirestore(_ order: OrderEntity) async throws {
        guard let orderID = order.orderID?.uuidString,
              let address = order.address,
              let status = order.status else {
            throw NetworkLayerError.invalidData
        }
        
        let orderData: [String: Any] = [
            "orderID": orderID,
            "productCost": order.productCost,
            "deliveryCharge": order.deliveryCharge,
            "promoCodeDiscount": order.promoCodeDiscount,
            "orderDate": order.orderDate ?? Date(),
            "paidByCard": order.paidByCard,
            "address": address,
            "latitude": order.latitude,
            "longitude": order.longitude,
            "orderComments": order.orderComments ?? "",
            "phone": order.phone ?? "",
            "status": status
        ]
        
        var itemsArray: [[String: Any]] = []
        if let orderItems = order.orderItems?.allObjects as? [OrderItemEntity] {
            for item in orderItems {
                guard let dishID = item.dishID,
                      let dishName = item.dishName else {
                    throw NetworkLayerError.invalidData
                }
                
                let itemData: [String: Any] = [
                    "dishID": dishID,
                    "dishName": dishName,
                    "dishPrice": item.dishPrice,
                    "quantity": item.quantity
                ]
                itemsArray.append(itemData)
            }
        }
        
        var fullOrderData = orderData
        fullOrderData["items"] = itemsArray

        let collectionPath: String
        if auth.currentUser == nil {
            collectionPath = "guestOrders"
        } else {
            collectionPath = "orders/\(auth.currentUser!.uid)/userOrders"
        }
        
        do {
            try await firestore.collection(collectionPath).document(orderID).setData(fullOrderData)
        } catch {
            throw NetworkLayerError.firestoreDataWasNotSaved(error)
        }
    }
    
    func fetchOrderHistoryFromFirestore() async throws -> [[String: Any]] {
        guard let user = auth.currentUser else {
            throw NetworkLayerError.authenticationFailed
        }
        
        let collectionPath = "orders/\(user.uid)/userOrders"
        do {
            let snapshot = try await firestore.collection(collectionPath).getDocuments()
            return snapshot.documents.map { $0.data() }
        } catch {
            throw NetworkLayerError.firestoreDataWasNotReceived(error)
        }
    }
    
    // MARK: - Private methods
    
    private func getFirestoreData(_ collectionName: String) async throws -> [DocumentSnapshot] {
      do {
        let snapshot = try await firestore.collection(collectionName).getDocuments()
        return snapshot.documents
      } catch {
        throw NetworkLayerError.firestoreDataWasNotReceived(error)
      }
    }

    private func createOffer(from data: DocumentSnapshot) async throws -> Offer {
        guard let offerData = try data.data(as: OfferDataModel?.self) else {
            throw NetworkLayerError.parseDataFailed
        }

        let imageData = try await downloadImage(from: offerData.imageURL)

        return Offer(id: offerData.id,
                     name: offerData.name,
                     amount: offerData.offer,
                     condition: offerData.condition,
                     imageData: imageData)
    }

    private func createDish(from data: DocumentSnapshot) async throws -> Dish {
        guard let dishData = try data.data(as: DishDataModel?.self) else {
            throw NetworkLayerError.parseDataFailed
        }

        let imageData = try await downloadImage(from: dishData.imageURL)

        return Dish(id: dishData.id,
                    name: dishData.name,
                    description: dishData.description,
                    ingredients: dishData.ingredients,
                    tags: dishData.tags,
                    weight: dishData.weight,
                    calories: dishData.calories,
                    protein: dishData.protein,
                    carbs: dishData.carbs,
                    fats: dishData.fats,
                    isOffer: dishData.isOffer,
                    price: dishData.price,
                    recentPrice: dishData.recentPrice,
                    imageData: imageData)
    }
    
}
