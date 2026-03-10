//
//  AuthCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

// MARK: - AuthCoordinatorDelegate
protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishAuth(_ coordinator: AuthCoordinator)
}

// MARK: - AuthCoordinator
final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: AuthCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showLogin()
    }

    func showLogin() {
        let viewController = WelcomeViewController()
        navigationController.setViewControllers(
            [viewController],
            animated: true
        )
    }

    func showRegister() {
        let viewModel = RegisterViewModel()
        let viewController = RegisterViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        viewController.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func didFinishAuth() {
        delegate?.didFinishAuth(self)
    }
}
