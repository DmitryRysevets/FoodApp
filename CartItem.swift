//
//  CartItem.swift
//  FoodApp
//

import Foundation

struct CartItem: Hashable {
    let id: Int
    let dish: Dish
    var quantity: Int
}
