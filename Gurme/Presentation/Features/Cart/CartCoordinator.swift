//
//  CartCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class CartCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let cartRepository = CartRepository()
        let viewModel = CartViewModel(
            cartRepository: cartRepository
        )
        let viewController = CartViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        viewController.coordinator = self
        navigationController.setViewControllers(
            [viewController],
            animated: false
        )
    }

    func showHome() {
        navigationController.tabBarController?.selectedIndex = 0
    }
}
