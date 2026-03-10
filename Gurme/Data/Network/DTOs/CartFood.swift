//
//  CartFood.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import Foundation

struct CartFood: Codable {
    let cartFoodId: String?
    let foodName: String?
    let foodImageName: String?
    let foodPrice: String?
    let orderCount: String?
    let userName: String?

    enum CodingKeys: String, CodingKey {
        case cartFoodId = "sepet_yemek_id"
        case foodName = "yemek_adi"
        case foodImageName = "yemek_resim_adi"
        case foodPrice = "yemek_fiyat"
        case orderCount = "yemek_siparis_adet"
        case userName = "kullanici_adi"
    }
}
