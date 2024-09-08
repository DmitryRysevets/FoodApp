//
//  OrderManager.swift
//  FoodApp
//

import Foundation

final class OrderManager {
    
    static let shared = OrderManager()

    private init() {}

    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    func placeOrder(orderID: UUID = UUID(), productCost: Double, deliveryCharge: Double, promoCodeDiscount: Double, orderDate: Date = Date(), paidByCard: Bool, address: String, latitude: Double, longitude: Double, orderComments: String?, phone: String?, status: String = "Pending", orderItems: [OrderItemEntity]) async throws {
        
        let order = coreDataManager.createOrder(orderID: orderID, productCost: productCost, deliveryCharge: deliveryCharge, promoCodeDiscount: promoCodeDiscount, orderDate: orderDate, paidByCard: paidByCard, address: address, latitude: latitude, longitude: longitude, orderComments: orderComments, phone: phone, status: status, orderItems: orderItems)

        do {
            try await networkManager.saveOrderToFirestore(order)
            coreDataManager.saveOrder(order)
        } catch {
            coreDataManager.deleteOrderFromContext(order)
            throw error
        }
    }

    func fetchOrderHistory() async throws {
        do {
            let firestoreOrders = try await networkManager.fetchOrderHistoryFromFirestore()
            coreDataManager.deleteAllOrders()
            coreDataManager.saveOrdersFromFirestore(firestoreOrders)
        } catch {
            throw error
        }
    }
}
