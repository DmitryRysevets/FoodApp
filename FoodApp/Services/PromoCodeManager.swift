//
//  PromoCodeManager.swift
//  FoodApp
//

import Foundation

enum PromoCodeManagerError: Error {
    case activePromoCodeAlreadyExists
    case failedToSavePromoCode
}

final class PromoCodeManager {
    
    static let shared = PromoCodeManager()
    
    private init() {}
    
    private let coreDataManager = CoreDataManager.shared
    private let firebaseManager = FirebaseManager.shared
    
    func applyPromoCode(_ code: String) async throws -> PromoCodeEntity {
        
        guard !coreDataManager.isActivePromoCodeAlreadyExists() else {
            throw PromoCodeManagerError.activePromoCodeAlreadyExists
        }
        
        let promoCodeData = try await firebaseManager.applyPromoCode(code)
        
        let promoCodeEntity = coreDataManager.createPromoCode(from: promoCodeData)
        
        do {
            try coreDataManager.saveContext()
            return promoCodeEntity
        } catch {
            try coreDataManager.deleteEntityFromContext(promoCodeEntity)
            throw PromoCodeManagerError.failedToSavePromoCode
        }
    }
    
    func getPromoCode() -> PromoCodeEntity? {
        do {
            return try coreDataManager.fetchPromoCode()
        } catch {
            return nil
        }
    }
    
    func deletePromoCode() throws {
        try coreDataManager.deletePromoCode()
    }
    
}
