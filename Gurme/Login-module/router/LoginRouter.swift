//
//  LoginRouter.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

final class LoginRouter: PresenterToRouterLoginProtocol {
    
    static func createRouter(ref: LoginVC) {
        
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
