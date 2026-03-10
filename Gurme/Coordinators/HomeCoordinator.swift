//
//  HomeCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let foodRepository = FoodRepository()
        let favoritesRepository = FavoritesRepository.shared
        let viewModel = HomeViewModel(
            foodRepository: foodRepository,
            favoritesRepository: favoritesRepository
        )
        let viewController = HomeViewController()
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
extension HomeCoordinator: FoodDetailCoordinatorDelegate {
    func didFinishFoodDetail(
        _ coordinator: FoodDetailCoordinator
    ) {
        removeChild(coordinator)
    }
}
