//
//  CreateAccountRouter.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

class CreateAccountRouter: PresenterToRouterCreateAccountProtocol {
    
    static func createModule(ref: VC_CreateAccount) {
        let presenter = CreateAccountPresenter()
        
        // View
        ref.createAccountPresenterObject = presenter
        
        // Presenter
       
        ref.createAccountPresenterObject?.createAccountInteractor = CreateAccountInteractor()
        ref.createAccountPresenterObject?.createAccountView = ref 
        
        //Interactor
        ref.createAccountPresenterObject?.createAccountInteractor?.createAccountPresenter = presenter
        
    }
}
