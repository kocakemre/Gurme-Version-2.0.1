//
//  CreateAccountProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

protocol ViewToPresenterCreateAccountProtocol {
    var createAccountInteractor: PresenterToInteractorCreateAccountProtocol? { get set }
    var createAccountView: PresenterToViewCreateAccountProtocol? { get set }
    
    func register(email: String, password: String)
}

protocol PresenterToInteractorCreateAccountProtocol {
    var createAccountPresenter: InteractorToPresenterCreateAccountProtocol? { get set }
    var createAccountError: String? {get set}
    
    func registerPerson(email: String, password: String)
}

protocol InteractorToPresenterCreateAccountProtocol {
    func dataTransferToPresenter(error: Bool)
}

protocol PresenterToViewCreateAccountProtocol {
    func dataTransferToView(error: Bool)
}

protocol PresenterToRouterCreateAccountProtocol {
    static func createModule(ref: VC_CreateAccount)
}
