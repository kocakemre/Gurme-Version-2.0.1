//
//  CreateAccountProtocols.swift
//  Gurme
//
//  Created by Emre Kocak on 29.09.2022.
//

import Foundation

protocol ViewToPresenterCreateAccountProtocol: AnyObject {
    
    var createAccountInteractor: PresenterToInteractorCreateAccountProtocol? { get set }
    var createAccountView: PresenterToViewCreateAccountProtocol? { get set }
    
    func register(email: String, password: String)
}

protocol PresenterToInteractorCreateAccountProtocol: AnyObject {
    
    var createAccountPresenter: InteractorToPresenterCreateAccountProtocol? { get set }
    var createAccountError: String? {get set}
    
    func registerPerson(email: String, password: String)
}

protocol InteractorToPresenterCreateAccountProtocol: AnyObject {
    
    func dataTransferToPresenter(error: Bool)
}

protocol PresenterToViewCreateAccountProtocol: AnyObject {
    
    func dataTransferToView(error: Bool)
}

protocol PresenterToRouterCreateAccountProtocol: AnyObject {
    
    static func createModule(ref: CreateAccountVC)
}
