//
//  CoreDataManager.swift
//  FoodApp
//

import Foundation
import CoreData
import FirebaseAuth

enum CoreDataManagerError: Error {
    case fetchError(Error)
    case saveError(Error)
    case deleteError(Error)
    
    case dishNotFound
    case favoriteNotFound
    case cartItemNotFound

    case clearCartError(Error)
    case batchDeleteError(Error)
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()

    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Base")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Menu methods
    
    func fetchMenu() throws -> Menu? {
        let fetchRequestDishes: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        let fetchRequestOffers: NSFetchRequest<OfferEntity> = OfferEntity.fetchRequest()
        let fetchRequestCategories: NSFetchRequest<CategoriesContainerEntity> = CategoriesContainerEntity.fetchRequest()
        
        do {
            let dishEntities = try context.fetch(fetchRequestDishes)
            let offerEntities = try context.fetch(fetchRequestOffers)
            let categoriesContainerEntities = try context.fetch(fetchRequestCategories)
            
            let dishes = dishEntities.map { Dish(from: $0) }
            let offers = offerEntities.map { Offer(from: $0) }
            let categories = (categoriesContainerEntities.first?.categories as? [String]) ?? []
            
            if dishes.isEmpty && offers.isEmpty && categories.isEmpty {
                return nil
            }
            
            return Menu(offers: offers, dishes: dishes, categories: categories)
            
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }

    
    func saveMenu(_ menu: Menu, version: String) throws {
        // Fetch existing favorite dish IDs
        let favoriteDishes = try fetchFavorites()
        let favoriteDishIDs = Set(favoriteDishes.map { $0.id })
        
        // Clear existing data
        do {
            try deleteMenu()
        } catch {
            throw CoreDataManagerError.deleteError(error)
        }
        
        // Save new menu data
        for dish in menu.dishes {
            let dishEntity = DishEntity(context: context)
            dishEntity.update(with: dish)
            if favoriteDishIDs.contains(dish.id) {
                dishEntity.isFavorite = true
            }
        }
        
        for offer in menu.offersContainer.offers {
            let offerEntity = OfferEntity(context: context)
            offerEntity.update(with: offer)
        }
        
        let categoriesContainerEntity = CategoriesContainerEntity(context: context)
        categoriesContainerEntity.categories = menu.categoriesContainer.categories as NSObject
        
        // Save menu version
        let fetchRequest: NSFetchRequest<MenuVersion> = MenuVersion.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            let versionNumber: MenuVersion
            if let existingVersionNumbers = results.first {
                versionNumber = existingVersionNumbers
            } else {
                versionNumber = MenuVersion(context: context)
            }
            
            versionNumber.version = version
        } catch {
            throw CoreDataManagerError.saveError(error)
        }
        
        saveContext()
    }

    
    func deleteMenu() throws {
        let fetchRequestDishes: NSFetchRequest<NSFetchRequestResult> = DishEntity.fetchRequest()
        let fetchRequestOffers: NSFetchRequest<NSFetchRequestResult> = OfferEntity.fetchRequest()
        let fetchRequestCategories: NSFetchRequest<NSFetchRequestResult> = CategoriesContainerEntity.fetchRequest()
        
        let batchDeleteRequestDishes = NSBatchDeleteRequest(fetchRequest: fetchRequestDishes)
        let batchDeleteRequestOffers = NSBatchDeleteRequest(fetchRequest: fetchRequestOffers)
        let batchDeleteRequestCategories = NSBatchDeleteRequest(fetchRequest: fetchRequestCategories)
        
        do {
            try context.execute(batchDeleteRequestDishes)
            try context.execute(batchDeleteRequestOffers)
            try context.execute(batchDeleteRequestCategories)
        } catch {
            throw CoreDataManagerError.deleteError(error)
        }
    }
    
    func isMenuDifferentFrom(_ newMenu: Menu) throws -> Bool {
        guard let existingMenu = try fetchMenu() else { return true }
        
        let existingDishIDs = Set(existingMenu.dishes.map { $0.id })
        let newDishIDs = Set(newMenu.dishes.map { $0.id })
        
        let existingOfferIDs = Set(existingMenu.offersContainer.offers.map { $0.id })
        let newOfferIDs = Set(newMenu.offersContainer.offers.map { $0.id })
        
        return existingDishIDs != newDishIDs || existingOfferIDs != newOfferIDs
    }
    
    func getCurrentMenuVersionNumber() throws -> String? {
        let fetchRequest: NSFetchRequest<MenuVersion> = MenuVersion.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.version
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    // MARK: - Favorite methods
    
    func fetchFavorites() throws -> [Dish] {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            let dishEntities = try context.fetch(fetchRequest)
            return dishEntities.map { Dish(from: $0) }
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    func setAsFavorite(by dishID: String) throws {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", dishID)
        
        do {
            let dishes = try context.fetch(fetchRequest)
            if let dish = dishes.first {
                dish.isFavorite = true
                saveContext()
            } else {
                throw CoreDataManagerError.favoriteNotFound
            }
        } catch {
            throw CoreDataManagerError.saveError(error)
        }
    }
    
    func deleteFromFavorite(by dishID: String) throws {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", dishID)
        
        do {
            let dishes = try context.fetch(fetchRequest)
            if let dish = dishes.first {
                dish.isFavorite = false
                saveContext()
            } else {
                throw CoreDataManagerError.favoriteNotFound
            }
        } catch {
            throw CoreDataManagerError.deleteError(error)
        }
    }
    
    // MARK: - Cart methods
    
    func saveCartItem(dish: Dish, quantity: Int) throws {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dishID == %@", dish.id)
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            
            if let existingCartItem = cartItems.first {
                existingCartItem.quantity += Int64(quantity)
            } else {
                let cartItemEntity = CartItemEntity(context: context)
                cartItemEntity.dishID = dish.id
                cartItemEntity.quantity = Int64(quantity)
            }
            
            saveContext()
            try CartStatusObserver.shared.observeCartStatus()
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    func deleteCartItem(by dishID: String) throws {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dishID == %@", dishID)
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            
            if let cartItem = cartItems.first {
                context.delete(cartItem)
                saveContext()
                try CartStatusObserver.shared.observeCartStatus()
            } else {
                print("Cart item with dishID \(dishID) not found.")
                throw CoreDataManagerError.cartItemNotFound
            }
        } catch {
            throw CoreDataManagerError.deleteError(error)
        }
    }
    
    func fetchCart() throws -> [CartItem] {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let cartItemEntities = try context.fetch(fetchRequest)
            var cartItems: [CartItem] = []
            
            for entity in cartItemEntities {
                do {
                    let dish = try fetchDish(by: entity.dishID!)
                    let cartItem = CartItem(dish: dish, quantity: Int(entity.quantity))
                    cartItems.append(cartItem)
                } catch {
                    continue
                }
                                
            }
            
            return cartItems
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    func saveCart(_ cartItems: [CartItem]) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartItemEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            
            for item in cartItems {
                let cartItemEntity = CartItemEntity(context: context)
                cartItemEntity.update(with: item)
            }
            
            saveContext()
        } catch {
            throw CoreDataManagerError.batchDeleteError(error)
        }
    }
    
    func clearCart() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartItemEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            saveContext()
            try CartStatusObserver.shared.observeCartStatus()
        } catch {
            throw CoreDataManagerError.clearCartError(error)
        }
    }
    
    func cartIsEmpty() throws -> Bool {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let itemCount = try context.count(for: fetchRequest)
            return itemCount == 0
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    // MARK: - Dish methods
    
    func findSimilarDishes(to dish: Dish, limit: Int = 3) throws -> [Dish] {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        
        do {
            let dishEntities = try context.fetch(fetchRequest)
            let dishes = dishEntities.map { Dish(from: $0) }
            let filteredDishes = dishes.filter { $0.id != dish.id }
            let similarDishes = filteredDishes.sorted { (dish1, dish2) -> Bool in
                return tagSimilarity(between: dish, and: dish1) > tagSimilarity(between: dish, and: dish2)
            }
            return Array(similarDishes.prefix(limit))
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    private func tagSimilarity(between dish1: Dish, and dish2: Dish) -> Int {
        let commonTags = Set(dish1.tags).intersection(Set(dish2.tags))
        return commonTags.count
    }
    
    func fetchDish(by id: String) throws -> Dish {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let dishes = try context.fetch(fetchRequest)
            if let dishEntity = dishes.first {
                return Dish(from: dishEntity)
            } else {
                throw CoreDataManagerError.dishNotFound
            }
        } catch {
            throw CoreDataManagerError.fetchError(error)
        }
    }
    
    // MARK: - Payment card methods
    
    func fetchAllCards() -> [CardEntity] {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch cards: \(error)")
            return []
        }
    }
    
    func saveCard(cardName: String, cardNumber: String, cardExpirationDate: String, cardCVC: String, cardholderName: String, isPreferred: Bool) throws {
        guard !cardNameExists(cardName) else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Card with this name already exists."])
        }
        
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        let cards = try context.fetch(fetchRequest)
        
        let shouldBePreferred = cards.isEmpty || isPreferred
        
        if shouldBePreferred {
            for card in cards {
                card.isPreferred = false
            }
        }
        
        let cardEntity = CardEntity(context: context)
        cardEntity.cardNumber = cardNumber
        cardEntity.cardName = cardName
        cardEntity.cardholderName = cardholderName
        cardEntity.cardExpirationDate = cardExpirationDate
        cardEntity.cardCVC = cardCVC
        cardEntity.isPreferred = shouldBePreferred
        
        saveContext()
    }
    
    func deleteCard(by cardName: String) {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cardName == %@", cardName)
        
        do {
            let cards = try context.fetch(fetchRequest)
            if let card = cards.first {
                context.delete(card)
            }
            saveContext()
        } catch {
            print("Failed to delete card: \(error)")
        }
    }
    
    func setPreferredCard(by cardName: String) {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        
        do {
            let cards = try context.fetch(fetchRequest)
            for card in cards {
                card.isPreferred = (card.cardName == cardName)
            }
            saveContext()
        } catch {
            print("Failed to set preferred card: \(error)")
        }
    }
    
    func getPreferredCardName() -> String? {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPreferred == true")
        fetchRequest.fetchLimit = 1
        
        do {
            if let preferredCard = try context.fetch(fetchRequest).first {
                return preferredCard.cardName
            }
        } catch {
            print("Failed to fetch preferred card: \(error)")
        }
        
        return nil
    }
    
    func cardNameExists(_ cardName: String) -> Bool {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cardName == %@", cardName)
        
        do {
            let cards = try context.fetch(fetchRequest)
            return !cards.isEmpty
        } catch {
            print("Failed to fetch card by cardName: \(error)")
            return false
        }
    }
    
    // MARK: - Delivery address methods
    
    func fetchAllAddresses() -> [AddressEntity] {
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch addresses: \(error)")
            return []
        }
    }
    
    func saveAddress(placeName: String, address: String, latitude: Double, longitude: Double, isDefaultAddress: Bool) throws {
        guard !placeNameExists(placeName) else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Address with this place name already exists."])
        }
        
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        let addresses = try context.fetch(fetchRequest)
        
        let shouldBeDefault = addresses.isEmpty || isDefaultAddress
        
        if shouldBeDefault {
            for address in addresses {
                address.isDefaultAddress = false
            }
        }
        
        let addressEntity = AddressEntity(context: context)
        addressEntity.placeName = placeName
        addressEntity.address = address
        addressEntity.latitude = latitude
        addressEntity.longitude = longitude
        addressEntity.isDefaultAddress = shouldBeDefault
        
        saveContext()
    }
    
    func updateAddress(oldPlaceName: String, newPlaceName: String, address: String, latitude: Double, longitude: Double) throws {
        if oldPlaceName != newPlaceName && placeNameExists(newPlaceName) {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Address with this new place name already exists."])
        }
        
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "placeName == %@", oldPlaceName)
        
        do {
            let addresses = try context.fetch(fetchRequest)
            
            if let addressEntity = addresses.first {
                addressEntity.placeName = newPlaceName
                addressEntity.address = address
                addressEntity.latitude = latitude
                addressEntity.longitude = longitude
                
                saveContext()
            } else {
                throw NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "Address with the old place name not found."])
            }
        } catch {
            print("Failed to update address: \(error)")
            throw NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch or update address."])
        }
    }
    
    func deleteAddress(by placeName: String) {
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "placeName == %@", placeName)
        
        do {
            let addresses = try context.fetch(fetchRequest)
            for address in addresses {
                context.delete(address)
            }
            saveContext()
        } catch {
            print("Failed to delete address: \(error)")
        }
    }
    
    func setAddressAsDefault(by placeName: String) {
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        
        do {
            let addresses = try context.fetch(fetchRequest)
            for address in addresses {
                address.isDefaultAddress = (address.placeName == placeName)
            }
            saveContext()
        } catch {
            print("Failed to set preferred address: \(error)")
        }
    }
    
    func getDefaultAddress() -> AddressEntity? {
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDefaultAddress == true")
        fetchRequest.fetchLimit = 1
        
        do {
            if let defaultAddress = try context.fetch(fetchRequest).first {
                return defaultAddress
            }
        } catch {
            print("Failed to fetch default address: \(error)")
        }
        
        return nil
    }
    
    func placeNameExists(_ placeName: String) -> Bool {
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "placeName == %@", placeName)
        
        do {
            let addresses = try context.fetch(fetchRequest)
            return !addresses.isEmpty
        } catch {
            print("Failed to fetch address by placeName: \(error)")
            return false
        }
    }
    
    // MARK: - User data methods
    
    func saveUser(_ user: User) {
        let userEntity = UserEntity(context: context)
        userEntity.id = user.uid
        userEntity.email = user.email
        userEntity.displayName = user.displayName
        userEntity.avatarURL = user.photoURL?.absoluteString
        saveContext()
    }

    func fetchUser() -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    func setDisplayName(_ name: String) {
        let user = fetchUser()
        user?.displayName = name
        saveContext()
    }
    
    func updateEmail(_ newEmail: String) {
        let user = fetchUser()
        user?.email = newEmail
        saveContext()
    }
    
    func savePhoneNumber(_ phoneNumber: String) {
        let user = fetchUser()
        user?.phoneNumber = phoneNumber
        saveContext()
    }
    
    func updateUserAvatar(avatarData: Data?, avatarURL: String?) {
        let user = fetchUser()
        user?.avatar = avatarData
        user?.avatarURL = avatarURL
        saveContext()
    }
    
    func updateUserAvatar(with avatarData: Data) {
        let user = fetchUser()
        user?.avatar = avatarData
        saveContext()
    }

    func deleteUser() {
        guard let user = fetchUser() else { return }
        context.delete(user)
        saveContext()
    }
    
    // MARK: - Orders methods
    
    func createOrder(orderID: UUID = UUID(), productCost: Double, deliveryCharge: Double, promoCodeDiscount: Double, orderDate: Date = Date(), paidByCard: Bool, address: String, latitude: Double, longitude: Double, orderComments: String?, phone: String?, status: String = "Pending", orderItems: [OrderItemEntity]) -> OrderEntity {
        let order = OrderEntity(context: context)
        order.orderID = orderID
        order.productCost = productCost
        order.deliveryCharge = deliveryCharge
        order.promoCodeDiscount = promoCodeDiscount
        order.orderComments = orderComments
        order.orderDate = orderDate
        order.paidByCard = paidByCard
        order.address = address
        order.latitude = latitude
        order.longitude = longitude
        order.phone = phone
        order.status = status
        
        for item in orderItems {
            order.addToOrderItems(item)
        }
        
        return order
    }
    
    func saveOrder(_ order: OrderEntity) {
        saveContext()
    }
    
    func saveOrdersFromFirestore(_ ordersData: [[String: Any]]) {
        let context = persistentContainer.viewContext

        for orderData in ordersData {
            let order = OrderEntity(context: context)

            order.orderID = orderData["orderID"] as? UUID ?? UUID()
            order.productCost = orderData["productCost"] as? Double ?? 0.0
            order.deliveryCharge = orderData["deliveryCharge"] as? Double ?? 0.0
            order.promoCodeDiscount = orderData["promoCodeDiscount"] as? Double ?? 0.0
            order.orderDate = orderData["orderDate"] as? Date ?? Date()
            order.paidByCard = orderData["paidByCard"] as? Bool ?? false
            order.address = orderData["address"] as? String ?? ""
            order.latitude = orderData["latitude"] as? Double ?? 0.0
            order.longitude = orderData["longitude"] as? Double ?? 0.0
            order.orderComments = orderData["orderComments"] as? String
            order.phone = orderData["phone"] as? String
            order.status = orderData["status"] as? String ?? "Pending"

            if let orderItemsData = orderData["orderItems"] as? [[String: Any]] {
                for itemData in orderItemsData {
                    let orderItem = OrderItemEntity(context: context)
                    orderItem.dishName = itemData["name"] as? String
                    orderItem.quantity = itemData["quantity"] as? Int64 ?? 0
                    orderItem.dishPrice = itemData["price"] as? Double ?? 0.0
                    order.addToOrderItems(orderItem)
                }
            }
        }

        saveContext()
    }
    
    func fetchOrders() -> [OrderEntity] {
        let request: NSFetchRequest<OrderEntity> = OrderEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "orderDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Order fetch error: \(error)")
            return []
        }
    }
    
    func deleteAllOrders() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = OrderEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting orders: \(error)")
        }
    }
    
    func deleteOrderFromContext(_ order: OrderEntity) {
        context.delete(order)
        saveContext()
    }
}
