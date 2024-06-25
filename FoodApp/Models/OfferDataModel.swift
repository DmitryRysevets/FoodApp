//
//  OfferDataModel.swift
//  FoodApp
//

import Foundation

struct OfferDataModel: Decodable {
    let id: String
    let name: String
    let offer: String
    let condition: String
    let imageURL: String
}
