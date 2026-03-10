//
//  LoginViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Firebase
import Foundation

// MARK: - LoginViewModelDelegate
protocol LoginViewModelDelegate: AnyObject {
    func didLoginSuccessfully()
    func didFailLogin(message: String)
}

// MARK: - LoginViewModel
final class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?

    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            delegate?.didFailLogin(
                message: "Email ve şifre boş bırakılamaz!"
            )
            return
        }
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { [weak self] _, error in
            if let error {
                self?.delegate?.didFailLogin(
                    message: error.localizedDescription
                )
            } else {
                self?.delegate?.didLoginSuccessfully()
            }
        }
    }

    func skipLogin() {
        delegate?.didLoginSuccessfully()
    }
}
