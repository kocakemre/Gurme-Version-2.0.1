//
//  CartPageProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import Foundation

protocol ViewToPresenterCartPageProtocol: AnyObject {
    
    var cartPageInteractor: PresenterToInteractorCartPageProtocol? {get set}
    var cartPageView: PresenterToViewCartPageProtocol? {get set}
    
    func bringFood()
    func delete(cart_food_id: String)
}

protocol PresenterToInteractorCartPageProtocol: AnyObject {
    
    var cartPagePresenter: InteractorToPresenterCartPageProtocol? {get set}

    func bringCartFood()
    func foodDelete(cart_food_id: String)
}

protocol InteractorToPresenterCartPageProtocol: AnyObject {
    
    func dataTransferToPresenter(cartFoodsLists: Array<CartFood>)
}
protocol PresenterToViewCartPageProtocol: AnyObject {
    
    func dataTransferToView(cartFoodsLists: Array<CartFood>)
}

protocol PresenterToRouterCartPageProtocol: AnyObject {
    
    static func createModule(ref: CartPageVC)
}
