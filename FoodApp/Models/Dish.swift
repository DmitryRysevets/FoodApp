//
//  Dish.swift
//  FoodApp
//

import Foundation

struct Dish: Hashable {
    let id: String
    let name: String
    let description: String
    let tags: [String]
    let weight: Int
    let calories: Int
    let protein: Int
    let carbs: Int
    let fats: Int
    let isOffer: Bool
    let price: Double
    let recentPrice: Double?
    let imageData: Data?
}
