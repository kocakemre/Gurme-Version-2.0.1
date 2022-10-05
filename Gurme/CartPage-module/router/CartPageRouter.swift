//
//  CartPageRouter.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import Foundation

class CartPageRouter: PresenterToRouterCartPageProtocol {
    
    static func createModule(ref: VC_CartPage) {
        
        let presenter : ViewToPresenterCartPageProtocol & InteractorToPresenterCartPageProtocol = CartPagePresenter()
        
        ref.cartPagePresenterObject = presenter
        
        ref.cartPagePresenterObject?.cartPageInteractor = CartPageInteractor()
        ref.cartPagePresenterObject?.cartPageView = ref
        
        ref.cartPagePresenterObject?.cartPageInteractor?.cartPagePresenter = presenter
    }
    
}
