//
//  CartCellViewModel.swift
//  FoodApp
//

import Foundation

protocol CartCellViewModelProtocol {
    var producImageData: Data? { get }
    var productName: String { get }
    var productWeight: String { get }
    var productPrice: String { get }
    var amountOfProduct: String { get }
    init(for dish: Dish, amount: String)
}

class CartCellViewModel: CartCellViewModelProtocol {
    
    var producImageData: Data?
    
    var productName: String
    
    var productWeight: String
    
    var productPrice: String
    
    var amountOfProduct: String
    
    required init(for dish: Dish, amount: String) {
        self.producImageData = dish.imageData
        self.productName = dish.name
        self.productWeight = String("\(dish.weight)g")
        self.productPrice = String("$\(dish.price)")
        self.amountOfProduct = amount
    }
    
    
}
