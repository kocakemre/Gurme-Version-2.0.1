//
//  AppDelegate.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Firebase
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Application Life Cycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: - UISceneSession Life Cycle
    func application(
        _ application: UIApplication,
        configurationForConnecting
            connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}

