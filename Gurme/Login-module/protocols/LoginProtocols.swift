//
//  LoginProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

protocol ViewToPresenterLoginProtocol {
    var loginInteractor: PresenterToInteractorLoginProtocol? { get set }
    var loginView: PresenterToViewLoginProtocol? { get set }
    
    func login(email: String, password: String)
}

protocol PresenterToInteractorLoginProtocol {
    var loginPresenter: InteractorToPresenterLoginProtocol? { get set }
    var loginContol: String? { get set } 
    func loginPerson(email: String, password: String)
}

protocol InteractorToPresenterLoginProtocol {
    func dataTransferToPresenter(isSuccess: Bool)
}

protocol PresenterToViewLoginProtocol {
    func dataTransferToView(isSuccess: Bool)
}

protocol PresenterToRouterLoginProtocol {
    static func createRouter(ref: VC_Login)
}
