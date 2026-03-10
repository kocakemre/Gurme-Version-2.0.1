//
//  SceneDelegate.swift
//  Gurme
//
//  Created by Emre Kocak on 24.09.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    // MARK: - Scene Life Cycle
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
