//
//  HomeViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
    func didUpdateFoods()
    func didUpdateFavoriteState()
    func didFailWithError(_ error: Error)
}

// MARK: - HomeViewModel
final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?

    private let foodRepository: FoodRepositoryInterface
    private let favoritesRepository: FavoritesRepositoryInterface

    private var allFoods: [Food] = []
    private(set) var filteredFoods: [Food] = []
    private(set) var sliderItems: [SliderItem] = []
    private var searchQuery = ""

    private enum Constant {
        static let sliderImagePrefix = "sliderGurme-"
        static let sliderCount = 6
    }

    init(
        foodRepository: FoodRepositoryInterface,
        favoritesRepository: FavoritesRepositoryInterface
    ) {
        self.foodRepository = foodRepository
        self.favoritesRepository = favoritesRepository
        self.favoritesRepository.addObserver(self)
        setupSliderItems()
    }

    deinit {
        favoritesRepository.removeObserver(self)
    }

    var sliderCount: Int {
        sliderItems.count
    }

    var foodCount: Int {
        filteredFoods.count
    }

    func food(at index: Int) -> Food? {
        guard index >= 0, index < filteredFoods.count else {
            return nil
        }
        return filteredFoods[index]
    }

    func fetchFoods() {
        Task { @MainActor in
            do {
                let foods = try await foodRepository.fetchAllFoods()
                self.allFoods = foods
                applySearchFilter()
                delegate?.didUpdateFoods()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }

    func searchFoods(query: String) {
        searchQuery = query
        applySearchFilter()
        delegate?.didUpdateFoods()
    }

    func toggleFavorite(for food: Food) {
        favoritesRepository.toggleFavorite(food)
    }

    func isFavorite(_ food: Food) -> Bool {
        favoritesRepository.isFavorite(food)
    }
}

// MARK: - Private Helpers
private extension HomeViewModel {
    func setupSliderItems() {
        sliderItems = (1...Constant.sliderCount).map { index in
            SliderItem(
                identifier: "\(Constant.sliderImagePrefix)\(index)",
                imageName: "\(Constant.sliderImagePrefix)\(index)"
            )
        }
    }

    func applySearchFilter() {
        if searchQuery.isEmpty {
            filteredFoods = allFoods
        } else {
            let lowercasedQuery = searchQuery.lowercased()
            filteredFoods = allFoods.filter {
                $0.name.lowercased().contains(lowercasedQuery)
            }
        }
    }
}

// MARK: - FavoritesObserver
extension HomeViewModel: FavoritesObserver {
    func favoritesDidUpdate(_ favorites: [Food]) {
        delegate?.didUpdateFavoriteState()
    }
}
