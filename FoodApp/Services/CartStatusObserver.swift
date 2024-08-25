//
//  CartStatusObserver.swift
//  FoodApp
//

import CoreData

final class CartStatusObserver {
    
    static let shared = CartStatusObserver()
    
    private init() {}
    
    private var isCartEmpty = true
    
    var cartStatusDidChange: ((Bool) -> Void)?
    
    func observeCartStatus() {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let cartItems = try CoreDataManager.shared.context.fetch(fetchRequest)
            let isCurrentlyEmpty = cartItems.isEmpty
            
            if isCurrentlyEmpty != isCartEmpty {
                isCartEmpty = isCurrentlyEmpty
                cartStatusDidChange?(isCartEmpty)
            }
        } catch {
            print("Failed to fetch cart items for observing: \(error)")
        }
    }
}
