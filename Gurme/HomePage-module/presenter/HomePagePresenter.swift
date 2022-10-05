//
//  HomePagePresenter.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

class HomePagePresenter: ViewToPresenterHomePageProtocol {
    
    var homePageInteractor: PresenterToInteractorHomePageProtocol?
    var homePageView: PresenterToViewHomePageProtocol?
    
    func allFoods() {
        homePageInteractor?.getAllFoods()
    }
    
    func search(food_name: String) {
        
    }
    
    func order(food_name: String, food_image_name: String, food_price: Int, food_order_count: Int, currentUser: String) {
        homePageInteractor?.addOrder(food_name: food_name, food_image_name: food_image_name, food_price: food_price, food_order_count: food_order_count, currentUser: currentUser)
    }
    
    
}

extension HomePagePresenter: InteractorToPresenterHomePageProtocol {
  
    func dataTransferToPresenter(foodList: Array<AllFood>) {
        homePageView?.dataTransferToView(foodList: foodList)
    }

}
