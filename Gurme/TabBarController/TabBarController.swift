//
//  TabBarController.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import UIKit

private class TabBarController: UITabBarController {
    
    static var customTabBarView = UIView(frame: .zero)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var firstViewController:UIViewController = UIViewController()
        // The following statement is what you need
        var customTabBarItem:UITabBarItem = UITabBarItem(
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
    
    // MARK: - Private Methods
    
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
    
//    private func setupTabBarUI() {
//        // Setup your colors and corner radius
//        self.tabBar.backgroundColor = UIColor.blue
//        //           self.tabBar.cornerRadius = 30
//        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        self.tabBar.backgroundColor = .red
//        self.tabBar.tintColor = .black
//        self.tabBar.unselectedItemTintColor = UIColor.yellow
//
//        // Remove the line
//        if #available(iOS 13.0, *) {
//            let appearance = self.tabBar.standardAppearance
//            appearance.shadowImage = nil
//            appearance.shadowColor = nil
//            self.tabBar.standardAppearance = appearance
//        } else {
//            self.tabBar.shadowImage = UIImage()
//            self.tabBar.backgroundImage = UIImage()
//        }
//    }
    
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
