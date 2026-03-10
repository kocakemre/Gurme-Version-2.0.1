//
//  AllFoodResponse.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

struct AllFoodResponse: Codable {
    let foods: [AllFood]?

    enum CodingKeys: String, CodingKey {
        case foods = "yemekler"
    }
}
