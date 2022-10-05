//
//  CreateAccountInteractor.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation
import Firebase
import FirebaseAuth

class CreateAccountInteractor: PresenterToInteractorCreateAccountProtocol {
    
    var createAccountPresenter: InteractorToPresenterCreateAccountProtocol?
    var createAccountError: String?
    let auth = Auth.auth()
    
    func registerPerson(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { _,error in
            if error != nil {
                self.createAccountError = error?.localizedDescription
                self.createAccountPresenter?.dataTransferToPresenter(error: true)
            }else {
                self.createAccountPresenter?.dataTransferToPresenter(error: false)
            }
        }
    }
    
    
}
