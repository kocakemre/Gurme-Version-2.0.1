//
//  CartPageProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import Foundation

protocol ViewToPresenterCartPageProtocol {
    
    var cartPageInteractor: PresenterToInteractorCartPageProtocol? {get set}
    var cartPageView: PresenterToViewCartPageProtocol? {get set}
    
    func bringFood()
    func delete(cart_food_id: String)
}

protocol PresenterToInteractorCartPageProtocol {
    
    var cartPagePresenter: InteractorToPresenterCartPageProtocol? {get set}

    func bringCartFood()
    func foodDelete(cart_food_id: String)
}

protocol InteractorToPresenterCartPageProtocol {
    func dataTransferToPresenter(cartFoodsLists: Array<CartFood>)
}
protocol PresenterToViewCartPageProtocol {
    func dataTransferToView(cartFoodsLists: Array<CartFood>)
}

protocol PresenterToRouterCartPageProtocol {
    static func createModule(ref: VC_CartPage)
}




