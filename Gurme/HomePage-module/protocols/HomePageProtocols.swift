//
//  HomePageProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

// MARK: - Main Protocols
protocol ViewToPresenterHomePageProtocol {
    var homePageInteractor: PresenterToInteractorHomePageProtocol? { get set }
    var homePageView: PresenterToViewHomePageProtocol? { get set }
    
    func allFoods()
    func search(food_name: String)
    func order(food_name: String, food_image_name: String, food_price: Int, food_order_count: Int, currentUser: String)
}

protocol PresenterToInteractorHomePageProtocol {
    var homePagePresenter: InteractorToPresenterHomePageProtocol? { get set }
    
    func getAllFoods()
    func searchFood(food_name: String)
    func addOrder(food_name: String, food_image_name: String, food_price: Int, food_order_count: Int, currentUser: String)
    
}

// MARK: - Transfer Protocols
protocol InteractorToPresenterHomePageProtocol {
    func dataTransferToPresenter(foodList: Array<AllFood>)
}

protocol PresenterToViewHomePageProtocol {
    func dataTransferToView(foodList: Array<AllFood>)
}

// MARK: - Router Protocols
protocol PresenterToRouterHomePageProtocol {
    static func createModule(ref: VC_HomePage)
}
