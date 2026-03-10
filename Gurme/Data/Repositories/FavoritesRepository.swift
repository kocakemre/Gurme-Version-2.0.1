//
//  FavoritesRepository.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - FavoritesObserver
protocol FavoritesObserver: AnyObject {
    func favoritesDidUpdate(_ favorites: [Food])
}

// MARK: - FavoritesRepositoryInterface
protocol FavoritesRepositoryInterface: AnyObject {
    var favorites: [Food] { get }
    func addObserver(_ observer: FavoritesObserver)
    func removeObserver(_ observer: FavoritesObserver)
    func toggleFavorite(_ food: Food)
    func isFavorite(_ food: Food) -> Bool
}

// MARK: - FavoritesRepository
final class FavoritesRepository: FavoritesRepositoryInterface {
    static let shared = FavoritesRepository()

    private let observers = NSHashTable<AnyObject>.weakObjects()
    private let userDefaults: UserDefaults
    private let storageKey = "savedFavorites"

    private(set) var favorites: [Food] = [] {
        didSet {
            notifyObservers()
        }
    }

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFromDisk()
    }

    func addObserver(_ observer: FavoritesObserver) {
        observers.add(observer)
    }

    func removeObserver(_ observer: FavoritesObserver) {
        observers.remove(observer)
    }

    func toggleFavorite(_ food: Food) {
        if let index = favorites.firstIndex(of: food) {
            favorites.remove(at: index)
        } else {
            favorites.append(food)
        }
        saveToDisk()
    }

    func isFavorite(_ food: Food) -> Bool {
        favorites.contains(food)
    }
}

// MARK: - Persistence
private extension FavoritesRepository {
    func saveToDisk() {
        guard let data = try? JSONEncoder().encode(favorites) else {
            return
        }
        userDefaults.set(data, forKey: storageKey)
    }

    func loadFromDisk() {
        guard let data = userDefaults.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode(
                  [Food].self,
                  from: data
              ) else {
            return
        }
        favorites = saved
    }
}

// MARK: - Observer Notification
private extension FavoritesRepository {
    func notifyObservers() {
        let allObservers = observers.allObjects
        for case let observer as FavoritesObserver in allObservers {
            observer.favoritesDidUpdate(favorites)
        }
    }
}
