//
//  FoodDetailPageRouter.swift
//  Gurme
//
//  Created by Emre Kocak on 1.10.2022.
//

import Foundation


class DetailPageRouter: PresenterToRouterDetailPageProtocol {
    
    static func createModule(ref: VC_FoodDetailPage) {
        let presenter = DetailPagePresenter()
        
        // View
        ref.detailPagePresenterObject = presenter
        
        // Presenter
        ref.detailPagePresenterObject?.detailInteractor = DetailPageInteractor()
        ref.detailPagePresenterObject?.detailView = ref
        
        // Interactor
        ref.detailPagePresenterObject?.detailInteractor?.detailPresenter = presenter
    }
}
