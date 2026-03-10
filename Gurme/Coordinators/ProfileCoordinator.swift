//
//  ProfileCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

// MARK: - ProfileCoordinatorDelegate
protocol ProfileCoordinatorDelegate: AnyObject {
    func didRequestLogout(_ coordinator: ProfileCoordinator)
}

// MARK: - ProfileCoordinator
final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: ProfileCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        viewController.coordinator = self
        navigationController.setViewControllers(
            [viewController],
            animated: false
        )
    }

    func didLogout() {
        delegate?.didRequestLogout(self)
    }
}
