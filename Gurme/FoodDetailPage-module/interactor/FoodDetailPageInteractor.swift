//
//  FoodDetailPageInteractor.swift
//  Gurme
//
//  Created by Emre Kocak on 1.10.2022.
//

import Foundation
import Alamofire

final class DetailPageInteractor: PresenterToInteractorDetailPageProtocol {
    
    weak var detailPresenter: InteractorToPresenterDetailPageProtocol?
    
    func addOrder(
        food_name: String,
        food_image_name: String,
        food_price: Int,
        food_order_count: Int,
        currentUser: String
    ) {
        let params: Parameters = [
            "yemek_adi": food_name,
            "yemek_resim_adi": food_image_name,
            "yemek_fiyat": food_price,
            "yemek_siparis_adet": food_order_count,
            "kullanici_adi": currentUser
        ]
        AF.request(
            "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php",
            method: .post,
            parameters: params
        ).response { response in
            guard let data = response.data else { return }
            do {
                let result = try JSONSerialization.jsonObject(with: data)
                print(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
