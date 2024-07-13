//
//  FoodDetailPageVC.swift
//  Gurme
//
//  Created by Emre Kocak on 1.10.2022.
//

import UIKit
import Kingfisher
import Firebase

final class FoodDetailPageVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet private weak var imageViewFood: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var labelFoodStar: UILabel!
    @IBOutlet private weak var labelFoodName: UILabel!
    @IBOutlet private weak var labelFoodDescription: UILabel!
    @IBOutlet private weak var labelTotalFoodPrice: UILabel!
    @IBOutlet private weak var labelFoodPrepareTime: UILabel!
    @IBOutlet private weak var labelFoodOrderCount: UILabel!
    
    // MARK: - Properties
    private var counter = 1
    var products: AllFood?
    weak var detailPagePresenterObject: DetailPagePresenter?
    private var currentUser = Auth.auth().currentUser?.email
    private var foodsList = [AllFood]()
    private var sumPrice: Int = 0
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.titleLabel?.text = ""
        backButton.tintColor = .white
        
        self.navigationControllerCustom()
        
        DetailPageRouter.createModule(ref: self)
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backButton.titleLabel?.text = ""
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backButton.titleLabel?.text = ""
    }
}

// MARK: - Other Methods
private
extension FoodDetailPageVC {
    
    func configureUI() {
        guard products != nil else { return }
        
        labelFoodName.text = products?.yemek_adi
        labelTotalFoodPrice.text = "\(products!.yemek_fiyat!) ₺"
        let baseUrl = "http://kasimadalan.pe.hu/yemekler/resimler/"
        imageViewFood.image = UIImage(systemName: "photo")
        
        if let url = URL(string: "\(baseUrl)\(products!.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                self.imageViewFood.kf.setImage(with: url)
            }
        }
        if CollectionViewCell_Foods.productInfo != nil {
            
            labelFoodStar.text = CollectionViewCell_Foods.productInfo?.star
            labelFoodDescription.text = CollectionViewCell_Foods.productInfo?.description
            labelFoodPrepareTime.text = CollectionViewCell_Foods.productInfo?.prepareTime
        }
    }
    
    func navigationControllerCustom() {
        
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(LoginVC.back(sender:))
        )
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")
        self.navigationController?.navigationBar.barStyle = .black
    }
}

// MARK: - Private Action Methods
private
extension FoodDetailPageVC {
    
    @IBAction func btnBack_TUI(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubtractProductClicked_TUI(_ sender: Any) {
        if labelFoodOrderCount.text == "1" {
            labelFoodOrderCount.text = "1"
            self.labelTotalFoodPrice.text = "\(products?.yemek_fiyat ?? "") ₺"
        } else {
            counter -= 1
            labelFoodOrderCount.text = String(counter)
        }
        let foodPriceInt = Int((products?.yemek_fiyat!)!)!
        
        self.sumPrice = counter * foodPriceInt
        
        self.labelTotalFoodPrice.text = "\(String(sumPrice)) ₺"
    }
    
    @IBAction func btnAddProductClicked_TUI(_ sender: Any) {
        
        counter += 1
        labelFoodOrderCount.text = String(counter)
        
        
        let foodPriceInt = Int((products?.yemek_fiyat!)!)!
        
        self.sumPrice = counter * foodPriceInt
        self.labelTotalFoodPrice.text = "\(String(sumPrice)) ₺"
        
    }
    
    @IBAction func btnAddProductToCart_TUI(_ sender: Any) {
        
        guard products != nil && labelFoodOrderCount.text != "0", let user = currentUser else {
            return
        }
        detailPagePresenterObject?.order(
            food_name: (products?.yemek_adi) ?? "",
            food_image_name: (products?.yemek_resim_adi) ?? "",
            food_price: Int(products?.yemek_fiyat ?? "0 ₺") ?? 0,
            food_order_count: counter,
            currentUser: user
        )
        
        labelFoodOrderCount.text = "0"
        let alert = UIAlertController(
            title: nil,
            message: "Ürünler sepete eklendi.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Devam Et", style: .default)
        let goBasket = UIAlertAction(title: "Sepete Git", style: .cancel) { _ in
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[1]
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(goBasket)
        present(alert, animated: true)
    }
}

// MARK: - PresenterToViewDetailPageProtocol
extension FoodDetailPageVC: PresenterToViewDetailPageProtocol {
    
    func dataTransferToView(foodsList: Array<AllFood>) {
        self.foodsList = foodsList
    }
}
