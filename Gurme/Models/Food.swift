//
//  Food.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - Food
struct Food: Codable, Hashable {
    let id: String
    let name: String
    let imageName: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case id = "yemek_id"
        case name = "yemek_adi"
        case imageName = "yemek_resim_adi"
        case price = "yemek_fiyat"
    }

    var imageURL: URL? {
        URL(string: "\(APIConstant.imageBaseURL)\(imageName)")
    }

    var priceValue: Int {
        Int(price) ?? 0
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Food, rhs: Food) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - FoodResponse
struct FoodResponse: Codable {
    let foods: [Food]?

    enum CodingKeys: String, CodingKey {
        case foods = "yemekler"
    }
}

// MARK: - CartItem
struct CartItem: Codable, Hashable {
    let cartId: String
    let name: String
    let imageName: String
    let price: String
    let orderCount: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case cartId = "sepet_yemek_id"
        case name = "yemek_adi"
        case imageName = "yemek_resim_adi"
        case price = "yemek_fiyat"
        case orderCount = "yemek_siparis_adet"
        case username = "kullanici_adi"
    }

    var imageURL: URL? {
        URL(string: "\(APIConstant.imageBaseURL)\(imageName)")
    }

    var priceValue: Int {
        Int(price) ?? 0
    }

    var orderCountValue: Int {
        Int(orderCount) ?? 0
    }

    var totalPrice: Int {
        priceValue * orderCountValue
    }
}

// MARK: - CartResponse
struct CartResponse: Codable {
    let items: [CartItem]?
    let success: Int?

    enum CodingKeys: String, CodingKey {
        case items = "sepet_yemekler"
        case success
    }
}

// MARK: - FoodDetail
struct FoodDetail {
    let starRating: String
    let description: String
    let prepareTime: String
}

// MARK: - SliderItem
struct SliderItem: Hashable {
    let identifier: String
    let imageName: String
}

// MARK: - APIConstant
enum APIConstant {
    static let imageBaseURL =
        "http://kasimadalan.pe.hu/yemekler/resimler/"
    static let allFoodsEndpoint = "tumYemekleriGetir.php"
    static let addToCartEndpoint = "sepeteYemekEkle.php"
    static let getCartEndpoint = "sepettekiYemekleriGetir.php"
    static let deleteFromCartEndpoint = "sepettenYemekSil.php"
}

// MARK: - GenericResponse
struct GenericResponse: Codable {
    let success: Int?
    let message: String?
}
