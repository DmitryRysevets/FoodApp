//
//  CartStatusObserver.swift
//  FoodApp
//

import CoreData

final class CartStatusObserver: NSObject, NSFetchedResultsControllerDelegate {
    
    private let fetchedResultsController: NSFetchedResultsController<CartItemEntity>
    
    var didChangeCartStatus: ((Bool) -> Void)?

    override init() {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dishID", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        notifyCartStatus()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notifyCartStatus()
    }
    
    private func notifyCartStatus() {
        let isEmpty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
        didChangeCartStatus?(isEmpty)
    }
}

