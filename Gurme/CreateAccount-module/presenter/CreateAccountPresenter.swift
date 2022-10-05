//
//  CreateAccountPresenter.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

class CreateAccountPresenter: ViewToPresenterCreateAccountProtocol {
    
    var createAccountView: PresenterToViewCreateAccountProtocol?
    var createAccountInteractor: PresenterToInteractorCreateAccountProtocol?
    
    func register(email: String, password: String) {
        createAccountInteractor?.registerPerson(email: email, password: password)
    }
    
}

    // MARK: - Extension

extension CreateAccountPresenter: InteractorToPresenterCreateAccountProtocol {
    
    func dataTransferToPresenter(error: Bool) {
        createAccountView?.dataTransferToView(error: error)
    }
    
}
