//
//  AppCoordinator.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Firebase
import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow

    private static let hasSeenOnBoardingKey = "hasSeenOnBoarding"

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        showSplash()
    }
}

// MARK: - Navigation
private extension AppCoordinator {
    func showSplash() {
        let splashVC = SplashScreenVC()
        splashVC.onComplete = { [weak self] in
            self?.routeAfterSplash()
        }
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }

    func routeAfterSplash() {
        let hasSeenOnBoarding = UserDefaults.standard.bool(
            forKey: AppCoordinator.hasSeenOnBoardingKey
        )
        if !hasSeenOnBoarding {
            showOnBoarding()
        } else if Auth.auth().currentUser != nil {
            showMainTab()
        } else {
            showAuth()
        }
    }

    func showOnBoarding() {
        let onBoardingVC = OnBoardingVC()
        onBoardingVC.onComplete = { [weak self] in
            UserDefaults.standard.set(true, forKey: AppCoordinator.hasSeenOnBoardingKey)
            if Auth.auth().currentUser != nil {
                self?.showMainTab()
            } else {
                self?.showAuth()
            }
        }
        transition(to: onBoardingVC)
    }

    func showMainTab() {
        let tabCoordinator = TabBarCoordinator(
            navigationController: navigationController
        )
        addChild(tabCoordinator)
        tabCoordinator.start()
        transition(to: tabCoordinator.tabBarController)
    }

    func showAuth() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController
        )
        authCoordinator.delegate = self
        addChild(authCoordinator)
        authCoordinator.start()
        transition(to: navigationController)
    }

    func transition(to viewController: UIViewController) {
        guard window.rootViewController !== viewController else { return }
        UIView.transition(
            with: window,
            duration: 0.35,
            options: .transitionCrossDissolve
        ) {
            // Disable UIKit's default transition animation during the swap
            let animationsEnabled = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window.rootViewController = viewController
            UIView.setAnimationsEnabled(animationsEnabled)
        }
    }
}

// MARK: - AuthCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishAuth(_ coordinator: AuthCoordinator) {
        removeChild(coordinator)
        showMainTab()
    }
}
