//
//  Menu.swift
//  FoodApp
//

import Foundation

struct Menu: Hashable {
    
    var offersContainer: OffersContainer
    var categoriesContainer = CategoriesContainer()
    let dishes: [Dish]
    
    init(offers: [Offer] = [], dishes: [Dish] = [], categories: [String] = []) {
        self.offersContainer = OffersContainer(offers: offers)
        self.dishes = dishes
        
        if categories.isEmpty {
            dishes.forEach { dish in
                for tag in dish.tags {
                    if !categoriesContainer.categories.contains(tag) {
                        categoriesContainer.categories.append(tag)
                    }
                }
            }
        } else {
            categoriesContainer.categories = categories
        }
    }
}
