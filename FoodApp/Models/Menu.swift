//
//  Menu.swift
//  FoodApp
//

import Foundation

struct Menu: Hashable {
    
    var offersContainer: OffersContainer
    var categoriesContainer = CategoriesContainer()
    let dishes: [Dish]
    
    init(offers: [Offer] = [], dishes: [Dish] = []) {
        self.offersContainer = OffersContainer(offers: offers)
        self.dishes = dishes
        
        dishes.forEach { dish in
            for tag in dish.tags {
                if !categoriesContainer.categories.contains(tag) {
                    categoriesContainer.categories.append(tag)
                }
            }
        }
        
    }
}
