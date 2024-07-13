//
//  LoginProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

protocol ViewToPresenterLoginProtocol: AnyObject {
    
    var loginInteractor: PresenterToInteractorLoginProtocol? { get set }
    var loginView: PresenterToViewLoginProtocol? { get set }
    
    func login(email: String, password: String)
}

protocol PresenterToInteractorLoginProtocol: AnyObject {
    var loginPresenter: InteractorToPresenterLoginProtocol? { get set }
    var loginContol: String? { get set } 
    func loginPerson(email: String, password: String)
}

protocol InteractorToPresenterLoginProtocol: AnyObject {
    func dataTransferToPresenter(isSuccess: Bool)
}

protocol PresenterToViewLoginProtocol: AnyObject {
    func dataTransferToView(isSuccess: Bool)
}

protocol PresenterToRouterLoginProtocol: AnyObject {
    static func createRouter(ref: LoginVC)
}
