//
//  TabBarCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

// MARK: - TabBarCoordinatorDelegate
protocol TabBarCoordinatorDelegate: AnyObject {
    func didRequestLogout(_ coordinator: TabBarCoordinator)
}

final class TabBarCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let tabBarController: UITabBarController
    weak var delegate: TabBarCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        let homeNavigationController = createNavigationController()
        let favoritesNavigationController = createNavigationController()
        let cartNavigationController = createNavigationController()
        let profileNavigationController = createNavigationController()

        let homeCoordinator = HomeCoordinator(
            navigationController: homeNavigationController
        )
        let favoritesCoordinator = FavoritesCoordinator(
            navigationController: favoritesNavigationController
        )
        let cartCoordinator = CartCoordinator(
            navigationController: cartNavigationController
        )
        let profileCoordinator = ProfileCoordinator(
            navigationController: profileNavigationController
        )

        profileCoordinator.delegate = self

        addChild(homeCoordinator)
        addChild(favoritesCoordinator)
        addChild(cartCoordinator)
        addChild(profileCoordinator)

        homeCoordinator.start()
        favoritesCoordinator.start()
        cartCoordinator.start()
        profileCoordinator.start()

        homeNavigationController.tabBarItem = UITabBarItem(
            title: Constant.Text.homeTitle,
            image: UIImage(systemName: Constant.Image.home),
            selectedImage: UIImage(
                systemName: Constant.Image.homeFill
            )
        )
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: Constant.Text.favoritesTitle,
            image: UIImage(
                systemName: Constant.Image.favorites
            ),
            selectedImage: UIImage(
                systemName: Constant.Image.favoritesFill
            )
        )
        cartNavigationController.tabBarItem = UITabBarItem(
            title: Constant.Text.cartTitle,
            image: UIImage(systemName: Constant.Image.cart),
            selectedImage: UIImage(
                systemName: Constant.Image.cartFill
            )
        )
        profileNavigationController.tabBarItem = UITabBarItem(
            title: Constant.Text.profileTitle,
            image: UIImage(systemName: Constant.Image.profile),
            selectedImage: UIImage(
                systemName: Constant.Image.profileFill
            )
        )

        tabBarController.viewControllers = [
            homeNavigationController,
            favoritesNavigationController,
            cartNavigationController,
            profileNavigationController
        ]
        tabBarController.tabBar.tintColor = UIColor(
            named: "MainOrangeColor"
        )
        tabBarController.delegate = self
        configureTabBarAppearance()
    }
}

// MARK: - Tab Bar Appearance
private extension TabBarCoordinator {
    func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }

    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - ProfileCoordinatorDelegate
extension TabBarCoordinator: ProfileCoordinatorDelegate {
    func didRequestLogout(_ coordinator: ProfileCoordinator) {
        delegate?.didRequestLogout(self)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        if viewController == tabBarController.selectedViewController,
           let navigationController = viewController
               as? UINavigationController,
           let homeViewController = navigationController
               .viewControllers.first as? HomeViewController {
            homeViewController.scrollToTop()
        }
        return true
    }
}

// MARK: - Constants
extension TabBarCoordinator {
    enum Constant {
        enum Image {
            static let home = "house"
            static let homeFill = "house.fill"
            static let favorites = "heart"
            static let favoritesFill = "heart.fill"
            static let cart = "cart"
            static let cartFill = "cart.fill"
            static let profile = "person"
            static let profileFill = "person.fill"
        }

        enum Text {
            static let homeTitle = "Ana Sayfa"
            static let favoritesTitle = "Favoriler"
            static let cartTitle = "Sepet"
            static let profileTitle = "Hesabım"
        }
    }
}
