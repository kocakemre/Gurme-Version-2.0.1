//
//  FoodDetailPagePresenter.swift
//  Gurme
//
//  Created by Emre Kocak on 1.10.2022.
//

import Foundation


class DetailPagePresenter: ViewToPresenterDetailPageProtocol {
    
    var detailInteractor: PresenterToInteractorDetailPageProtocol?
    var detailView: PresenterToViewDetailPageProtocol?
    
    func order(food_name: String, food_image_name: String, food_price: Int, food_order_count: Int, currentUser: String) {
        detailInteractor?.addOrder(food_name: food_name, food_image_name: food_image_name, food_price: food_price, food_order_count: food_order_count, currentUser: currentUser)
    }
    
    
}

extension DetailPagePresenter: InteractorToPresenterDetailPageProtocol {
    
    func dataTransferToPresenter(foodsList: Array<AllFood>) {
        detailView?.dataTransferToView(foodsList: foodsList)
    }
    
}
