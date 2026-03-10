//
//  FoodRepository.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - FoodRepositoryInterface
protocol FoodRepositoryInterface: AnyObject {
    func fetchAllFoods() async throws -> [Food]
}

// MARK: - FoodRepository
final class FoodRepository: FoodRepositoryInterface {
    private let networkService: NetworkService

    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }

    func fetchAllFoods() async throws -> [Food] {
        let response: FoodResponse = try await networkService.request(
            endpoint: APIConstant.allFoodsEndpoint,
            method: .get
        )
        return response.foods ?? []
    }
}
