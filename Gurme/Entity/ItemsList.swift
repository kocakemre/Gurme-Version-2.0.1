//
//  ItemsList.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

class ItemsList {
    
    var foodName: String?
    var foodOrderCount: Int?
    var foodPrice: Int?
    var food_id: [String]?
    
    init(
        foodName: String,
        foodOrderCount: Int,
        foodPrice: Int,
        food_id: [String]
    ) {
        self.foodName = foodName
        self.foodOrderCount = foodOrderCount
        self.foodPrice = foodPrice
        self.food_id = food_id
    }
}
