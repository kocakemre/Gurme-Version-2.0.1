//
//  CartPageInteractor.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import Foundation
import Alamofire
import Firebase

class CartPageInteractor: PresenterToInteractorCartPageProtocol {
    
    var cartPagePresenter: InteractorToPresenterCartPageProtocol?
    let currentUser = Auth.auth().currentUser?.email
    
    func bringCartFood() {
        
        let params: Parameters = ["kullanici_adi": currentUser!]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(CartFoodResponse.self, from: data)
                    if let list = result.sepet_yemekler {
                        self.cartPagePresenter?.dataTransferToPresenter(cartFoodsLists: list)
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func foodDelete(cart_food_id: String) {
        let params: Parameters = ["sepet_yemek_id": cart_food_id, "kullanici_adi": currentUser!]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data)
                    print(result)
                    
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}

