//
//  NetworkManager.swift
//  FoodApp
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

enum NetworkLayerError: Error {
    case parseDataFailed
    case downloadImageFailed(Error)
    case firestoreDataWasNotReceived(Error)
    case invalidData
//    case networkError(Error)
//    case authenticationError
}

class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()

    func getMenu() async throws -> (dishes: [Dish], offers: [Offer]) {
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

        return (dishes: dishes, offers: offers)
    }
    
    // MARK: - private methods
    
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

    private func downloadImage(from url: String) async throws -> Data {
        let imageStorageReference = storage.reference(forURL: url)
        let maxImageSize: Int64 = 2 * 1024 * 1024 // 2MB

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
}






/*
class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()

    func getMenu(completion: @escaping (Result<(dishes: [Dish], offers: [Offer]), NetworkLayerError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var offers: [Offer] = []
        var dishes: [Dish] = []
        
        firestore.collection("offers").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(NetworkLayerError.firestoreDataWasNotReceived(error)))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NetworkLayerError.invalidData))
                return
            }
            
            for document in documents {
                do {
                    if let offerData = try document.data(as: OfferDataModel?.self) {
                        dispatchGroup.enter()
                        
                        self.downloadImage(from: offerData.imageURL) { result in
                            dispatchGroup.leave()
                            
                            switch result {
                            case .success(let imageData):
                                let offer = Offer(id: offerData.id, 
                                                  name: offerData.name,
                                                  offer: offerData.offer,
                                                  condition: offerData.condition,
                                                  imageData: imageData)
                                offers.append(offer)
                                
                            case .failure(let error):
                                completion(.failure(NetworkLayerError.downloadImageFailed(error)))
                                return
                            }
                        }
                    }
                } catch {
                    print("Error decoding offer document: \(error)")
                    completion(.failure(NetworkLayerError.parseDataFailed))
                    return
                }
            }
            
        }

        firestore.collection("menu").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(NetworkLayerError.firestoreDataWasNotReceived(error)))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.failure(NetworkLayerError.invalidData))
                return
            }

            for document in documents {
                do {
                    if let dishData = try document.data(as: DishDataModel?.self) {
                        dispatchGroup.enter()

                        self.downloadImage(from: dishData.imageURL) { result in
                            defer { dispatchGroup.leave() }

                            switch result {
                            case .success(let imageData):
                                let dish = Dish(id: dishData.id,
                                                name: dishData.name,
                                                description: dishData.description,
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
                                dishes.append(dish)
                                
                            case .failure(let error):
                                completion(.failure(NetworkLayerError.downloadImageFailed(error)))
                                return
                            }
                        }
                    }
                } catch {
                    print("Error decoding dish document: \(error)")
                    completion(.failure(NetworkLayerError.parseDataFailed))
                    return
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(.success((dishes: dishes, offers: offers)))
            }
        }
    }

    private func downloadImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let imageStorageReference = storage.reference(forURL: url)
        let maxImageSize: Int64 = 2 * 1024 * 1024 // 2MB

        imageStorageReference.getData(maxSize: maxImageSize) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(data!))
        }
    }

}
*/




