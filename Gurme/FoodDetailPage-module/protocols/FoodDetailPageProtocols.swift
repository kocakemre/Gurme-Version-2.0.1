//
//  FoodDetailPageProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 1.10.2022.
//

import Foundation

// MARK: - Main Protocols
protocol ViewToPresenterDetailPageProtocol: AnyObject {
    
    var detailInteractor: PresenterToInteractorDetailPageProtocol? { get set }
    var detailView: PresenterToViewDetailPageProtocol? { get set }
    
    func order(
        food_name: String,
        food_image_name: String,
        food_price: Int,
        food_order_count: Int,
        currentUser: String
    )
}

protocol PresenterToInteractorDetailPageProtocol: AnyObject {
    
    var detailPresenter: InteractorToPresenterDetailPageProtocol? { get set }
    
    func addOrder(
        food_name: String,
        food_image_name: String,
        food_price: Int,
        food_order_count: Int,
        currentUser: String
    )
}

// MARK: - Transfer Protocols
protocol InteractorToPresenterDetailPageProtocol: AnyObject {
    func dataTransferToPresenter(foodsList: Array<AllFood>)
}

protocol PresenterToViewDetailPageProtocol: AnyObject {
    func dataTransferToView(foodsList: Array<AllFood>)
}

// MARK: - Router Protocols
protocol PresenterToRouterDetailPageProtocol: AnyObject {
    static func createModule(ref: FoodDetailPageVC)
}
