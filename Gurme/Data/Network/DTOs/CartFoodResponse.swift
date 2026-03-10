//
//  CartFoodResponse.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

struct CartFoodResponse: Codable {
    let cartFoods: [CartFood]?
    let success: Int?

    enum CodingKeys: String, CodingKey {
        case cartFoods = "sepet_yemekler"
        case success
    }
}

