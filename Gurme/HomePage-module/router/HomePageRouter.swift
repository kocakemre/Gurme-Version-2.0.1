//
//  HomePageRouter.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

class HomePageRouter: PresenterToRouterHomePageProtocol {
    
    static func createModule(ref: VC_HomePage) {
        let presenter = HomePagePresenter()
        
        // View
        ref.homePagePresenterObject = presenter
        
        // Presenter
        ref.homePagePresenterObject?.homePageInteractor = HomePageInteractor()
        ref.homePagePresenterObject?.homePageView = ref
        
        // Interactor
        ref.homePagePresenterObject?.homePageInteractor?.homePagePresenter = presenter
    }
    

}
