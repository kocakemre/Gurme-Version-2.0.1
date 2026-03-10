//
//  FavoritesCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let favoritesRepository = FavoritesRepository.shared
        let viewModel = FavoritesViewModel(
            favoritesRepository: favoritesRepository
        )
        let viewController = FavoritesViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        viewController.coordinator = self
        navigationController.setViewControllers(
            [viewController],
            animated: false
        )
    }

    func showFoodDetail(food: Food) {
        let coordinator = FoodDetailCoordinator(
            navigationController: navigationController,
            food: food
        )
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }
}

// MARK: - FoodDetailCoordinatorDelegate
extension FavoritesCoordinator: FoodDetailCoordinatorDelegate {
    func didFinishFoodDetail(
        _ coordinator: FoodDetailCoordinator
    ) {
        removeChild(coordinator)
    }
}
