//
//  CartFoodResponse.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

struct CartFoodResponse: Codable {
    
    var sepet_yemekler: [CartFood]?
    var success:Int?
}

