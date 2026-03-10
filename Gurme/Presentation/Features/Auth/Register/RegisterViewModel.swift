//
//  RegisterViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Firebase
import Foundation

// MARK: - RegisterViewModelDelegate
protocol RegisterViewModelDelegate: AnyObject {
    func didRegisterSuccessfully()
    func didFailRegister(message: String)
}

// MARK: - RegisterViewModel
final class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?

    func register(
        email: String,
        password: String,
        confirmPassword: String,
        name: String,
        surname: String
    ) {
        guard !email.isEmpty,
              !password.isEmpty,
              !name.isEmpty,
              !surname.isEmpty else {
            delegate?.didFailRegister(
                message: "Lütfen boş alanları doldurunuz!"
            )
            return
        }

        guard password == confirmPassword else {
            delegate?.didFailRegister(
                message: "Parolalar uyuşmamaktadır."
            )
            return
        }

        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { [weak self] _, error in
            if let error {
                self?.delegate?.didFailRegister(
                    message: error.localizedDescription
                )
            } else {
                self?.delegate?.didRegisterSuccessfully()
            }
        }
    }
}
