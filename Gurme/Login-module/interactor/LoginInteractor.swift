//
//  LoginInteractor.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation
import Firebase

final class LoginInteractor: PresenterToInteractorLoginProtocol {
    
    var loginPresenter: InteractorToPresenterLoginProtocol?
    var loginContol: String?
    
    func loginPerson(email: String, password: String) {
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password) { _, error in
//            if error != nil {
//                self.loginContol = error?.localizedDescription
//                self.loginPresenter?.dataTransferToPresenter(isSuccess: false)
//            } else {
//                self.loginPresenter?.dataTransferToPresenter(isSuccess: true)
//            }
            
            self.loginPresenter?.dataTransferToPresenter(isSuccess: true)
        }
    }
}
