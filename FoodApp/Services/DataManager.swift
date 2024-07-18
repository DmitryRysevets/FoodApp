//
//  DataManager.swift
//  FoodApp
//

import CoreData
import UIKit

final class DataManager {
    
    static let shared = DataManager()

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
    
    // MARK: - Data methods
    
    func fetchMenu() -> Menu? {
        let fetchRequestDishes: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        let fetchRequestOffers: NSFetchRequest<OfferEntity> = OfferEntity.fetchRequest()
        let fetchRequestCategories: NSFetchRequest<CategoriesContainerEntity> = CategoriesContainerEntity.fetchRequest()
        
        do {
            let dishEntities = try context.fetch(fetchRequestDishes)
            let offerEntities = try context.fetch(fetchRequestOffers)
            let categoriesContainerEntities = try context.fetch(fetchRequestCategories)
            
            let dishes = dishEntities.map { Dish(from: $0) }
            let offers = offerEntities.map { Offer(from: $0) }
            let categories = (categoriesContainerEntities.first?.categories as? [String]) ?? ["All"]
            
            return Menu(offers: offers, dishes: dishes, categories: categories)
        } catch {
            print("Failed to fetch menu: \(error)")
            return nil
        }
    }
    
    
    func saveMenu(_ menu: Menu) {
        // Fetch existing favorite dish IDs
        let favoriteDishes = fetchFavorite()
        let favoriteDishIDs = Set(favoriteDishes.map { $0.id })
        
        // Clear existing data
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
            print("Failed to clear existing data: \(error)")
        }
        
        // Save new data
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
        
        saveContext()
    }
    
    
    func fetchFavorite() -> [Dish] {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            let dishEntities = try context.fetch(fetchRequest)
            return dishEntities.map { Dish(from: $0) }
        } catch {
            print("Failed to fetch favorite dishes: \(error)")
            return []
        }
    }
    
    
    func setAsFavorite(dishID: String) {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", dishID)
        
        do {
            let dishes = try context.fetch(fetchRequest)
            if let dish = dishes.first {
                dish.isFavorite = true
                saveContext()
            }
        } catch {
            print("Failed to set as favorite: \(error)")
        }
    }
    
    
    func deleteFromFavorite(dishID: String) {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", dishID)
        
        do {
            let dishes = try context.fetch(fetchRequest)
            if let dish = dishes.first {
                dish.isFavorite = false
                saveContext()
            }
        } catch {
            print("Failed to delete from favorite: \(error)")
        }
    }
    
    
    func menusAreDifferent(_ newMenu: Menu) -> Bool {
        guard let existingMenu = fetchMenu() else { return true }
        
        let existingDishIDs = Set(existingMenu.dishes.map { $0.id })
        let newDishIDs = Set(newMenu.dishes.map { $0.id })
        
        let existingOfferIDs = Set(existingMenu.offersContainer.offers.map { $0.id })
        let newOfferIDs = Set(newMenu.offersContainer.offers.map { $0.id })
        
        return existingDishIDs != newDishIDs || existingOfferIDs != newOfferIDs
    }
    
}
