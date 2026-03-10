//
//  FoodDetailCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

// MARK: - FoodDetailCoordinatorDelegate
protocol FoodDetailCoordinatorDelegate: AnyObject {
    func didFinishFoodDetail(
        _ coordinator: FoodDetailCoordinator
    )
}

// MARK: - FoodDetailCoordinator
final class FoodDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: FoodDetailCoordinatorDelegate?

    private let food: Food

    init(
        navigationController: UINavigationController,
        food: Food
    ) {
        self.navigationController = navigationController
        self.food = food
    }

    func start() {
        let cartRepository = CartRepository()
        let viewModel = FoodDetailViewModel(
            food: food,
            cartRepository: cartRepository
        )
        let viewController = FoodDetailViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        viewController.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func didFinish() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishFoodDetail(self)
    }
}
