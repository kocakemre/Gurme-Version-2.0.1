//
//  LoginRouter.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

class LoginRouter: PresenterToRouterLoginProtocol {
    
    static func createRouter(ref: VC_Login) {
        
        let presenter = LoginPresenter()
        
        // View
        ref.loginPresenterObject = presenter
        
        // Presenter
        ref.loginPresenterObject?.loginInteractor = LoginInteractor()
        ref.loginPresenterObject?.loginView = ref
        
        // Interactor
        ref.loginPresenterObject?.loginInteractor?.loginPresenter = presenter
    }
    
}
