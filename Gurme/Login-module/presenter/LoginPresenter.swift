//
//  LoginPresenter.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

class LoginPresenter: ViewToPresenterLoginProtocol {
    
    var loginInteractor: PresenterToInteractorLoginProtocol?
    var loginView: PresenterToViewLoginProtocol?
    
    func login(email: String, password: String) {
        loginInteractor?.loginPerson(email: email, password: password)
    }
}

extension LoginPresenter: InteractorToPresenterLoginProtocol {
   
    func dataTransferToPresenter(isSuccess: Bool) {
        loginView?.dataTransferToView(isSuccess: isSuccess)
    }
    
}
