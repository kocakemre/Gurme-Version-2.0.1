//
//  TabBarController.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import UIKit

private final class TabBarController: UITabBarController {
    
    static var customTabBarView = UIView(frame: .zero)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController:UIViewController = UIViewController()
        // The following statement is what you need
        let customTabBarItem:UITabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "foodIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
            selectedImage: UIImage(named: "foodIcon")
        )
        firstViewController.tabBarItem = customTabBarItem
        
        self.tabBar.tintColor = UIColor(named: "MainOrangeColor")
        
        
        self.addCustomTabBarView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupCustomTabBarFrame()
    }
}

// MARK: - Private Methods
extension TabBarController {
    
    private func setupCustomTabBarFrame() {
        let height = self.view.safeAreaInsets.bottom + 64
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        TabBarController.customTabBarView.frame = tabBar.frame
    }
    
    private func addCustomTabBarView() {
        
        TabBarController.customTabBarView.frame = tabBar.frame
        self.tabBar.layer.cornerRadius = 40
        TabBarController.customTabBarView.backgroundColor = .white
        TabBarController.customTabBarView.layer.cornerRadius = 30
        TabBarController.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        TabBarController.customTabBarView.layer.masksToBounds = false
        TabBarController.customTabBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        TabBarController.customTabBarView.layer.shadowOffset = CGSize(width: -4, height: -6)
        TabBarController.customTabBarView.layer.shadowOpacity = 0.5
        TabBarController.customTabBarView.layer.shadowRadius = 20
        
        self.view.addSubview(TabBarController.customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }
}
