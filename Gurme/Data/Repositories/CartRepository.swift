//
//  CartRepository.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - CartRepositoryInterface
protocol CartRepositoryInterface: AnyObject {
    func fetchCartItems(username: String) async throws -> [CartItem]
    func addToCart(
        foodName: String,
        imageName: String,
        price: Int,
        orderCount: Int,
        username: String
    ) async throws
    func deleteFromCart(
        cartItemId: String,
        username: String
    ) async throws
}

// MARK: - CartRepository
final class CartRepository: CartRepositoryInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }

    func fetchCartItems(username: String) async throws -> [CartItem] {
        let params: [String: Any] = ["kullanici_adi": username]
        let response: CartResponse = try await networkService.request(
            endpoint: APIConstant.getCartEndpoint,
            method: .post,
            parameters: params
        )
        return response.items ?? []
    }

    func addToCart(
        foodName: String,
        imageName: String,
        price: Int,
        orderCount: Int,
        username: String
    ) async throws {
        let params: [String: Any] = [
            "yemek_adi": foodName,
            "yemek_resim_adi": imageName,
            "yemek_fiyat": price,
            "yemek_siparis_adet": orderCount,
            "kullanici_adi": username
        ]
        let _: GenericResponse = try await networkService.request(
            endpoint: APIConstant.addToCartEndpoint,
            method: .post,
            parameters: params
        )
    }

    func deleteFromCart(
        cartItemId: String,
        username: String
    ) async throws {
        let params: [String: Any] = [
            "sepet_yemek_id": cartItemId,
            "kullanici_adi": username
        ]
        let _: GenericResponse = try await networkService.request(
            endpoint: APIConstant.deleteFromCartEndpoint,
            method: .post,
            parameters: params
        )
    }
}
