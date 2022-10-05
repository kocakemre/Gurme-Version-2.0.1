//
//  CartPagePresenter.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import Foundation

class CartPagePresenter: ViewToPresenterCartPageProtocol {
    var cartPageInteractor: PresenterToInteractorCartPageProtocol?
    
    var cartPageView: PresenterToViewCartPageProtocol?
    
    func bringFood() {
        cartPageInteractor?.bringCartFood()
    }
    
    func delete(cart_food_id: String) {
        cartPageInteractor?.foodDelete(cart_food_id: cart_food_id)
    }
   

}

extension CartPagePresenter: InteractorToPresenterCartPageProtocol {
    
    func dataTransferToPresenter(cartFoodsLists: Array<CartFood>) {
        cartPageView?.dataTransferToView(cartFoodsLists: cartFoodsLists)
    }
    
 
}
