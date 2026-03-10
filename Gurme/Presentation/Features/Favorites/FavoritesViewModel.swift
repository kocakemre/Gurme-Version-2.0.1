//
//  FavoritesViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - FavoritesViewModelDelegate
protocol FavoritesViewModelDelegate: AnyObject {
    func didUpdateFavorites()
}

// MARK: - FavoritesViewModel
final class FavoritesViewModel {
    weak var delegate: FavoritesViewModelDelegate?

    private let favoritesRepository: FavoritesRepositoryInterface

    private(set) var favorites: [Food] = []

    init(
        favoritesRepository: FavoritesRepositoryInterface
    ) {
        self.favoritesRepository = favoritesRepository
        self.favoritesRepository.addObserver(self)
        loadFavorites()
    }

    deinit {
        favoritesRepository.removeObserver(self)
    }

    var itemCount: Int {
        favorites.count
    }

    var isEmpty: Bool {
        favorites.isEmpty
    }

    func food(at index: Int) -> Food? {
        guard index >= 0, index < favorites.count else {
            return nil
        }
        return favorites[index]
    }

    func removeFavorite(at index: Int) {
        guard let food = food(at: index) else { return }
        favoritesRepository.toggleFavorite(food)
    }

    func loadFavorites() {
        favorites = favoritesRepository.favorites
    }
}

// MARK: - FavoritesObserver
extension FavoritesViewModel: FavoritesObserver {
    func favoritesDidUpdate(_ favorites: [Food]) {
        self.favorites = favorites
        delegate?.didUpdateFavorites()
    }
}
