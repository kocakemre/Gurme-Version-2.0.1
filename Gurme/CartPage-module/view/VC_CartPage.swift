//
//  VC_CartPage.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import UIKit
import Lottie
import Firebase

class ItemsList {
    
    var foodName: String?
    var foodOrderCount: Int?
    var foodPrice: Int?
    var food_id: [String]?
    
    init(foodName: String, foodOrderCount: Int, foodPrice: Int, food_id: [String]) {
        self.foodName = foodName
        self.foodOrderCount = foodOrderCount
        self.foodPrice = foodPrice
        self.food_id = food_id
    }
}

class VC_CartPage: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var tableViewCart: UITableView!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var confirmLottieView: AnimationView!
    @IBOutlet weak var btnCartConfirm: UIButton!
    @IBOutlet weak var btnTrash: UIButton!
    
    var foods = [CartFood]()
    
    var cartPagePresenterObject: ViewToPresenterCartPageProtocol?
   
    
    var filteredFoodArray = [ItemsList]()
    var sum : Int = 0
    var priceCalculation = 0.0
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTrash.titleLabel?.text = ""
        self.cartAnimation()
      
        tableViewCart.delegate = self
        tableViewCart.dataSource = self
        confirmLottieView.isHidden = true
        CartPageRouter.createModule(ref: self)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartPagePresenterObject?.bringFood()
        
        self.get_total()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnTrash.titleLabel?.text = ""
        
        self.cartAnimation()
        self.tableViewCart.reloadData()
    }
    
    // MARK: - Methods
    
    func cartConfirmAnimation() {
        
        let animation = Animation.named("tik")
        confirmLottieView.animation = animation
        confirmLottieView.loopMode = .playOnce
        confirmLottieView.animationSpeed = 0.5
        
        if (!confirmLottieView.isAnimationPlaying){
            confirmLottieView.play()
        }
    }
    
    func cartAnimation() {
        
        let animation = Animation.named("deliveryBike")
        lottieView.animation = animation
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        
        if (!lottieView.isAnimationPlaying){
            lottieView.play()
        }
    }
    
    func get_total(){
        var total = 0
        var textToplam : Int = 0
        
        for yemek in foods {
            total = Int(yemek.yemek_siparis_adet!)! * Int(yemek.yemek_fiyat!)!
            textToplam += total
            
        }
        labelTotalPrice.text = "TOTAL: \(String(textToplam)) TL"
        
    }

  
    // MARK: - UI Elements

    @IBAction func btnTrash_TUI(_ sender: Any) {
        let alert = UIAlertController(title: "Uyarı", message: "Sepetinizdeki tüm ürünler silinsin mi?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Vazgeç", style: .default)
        let delete = UIAlertAction(title: "Sil", style: .destructive) { [self] _ in
            for food in self.foods {
                self.cartPagePresenterObject?.delete(cart_food_id: food.sepet_yemek_id!)
              
            }
            self.foods.removeAll()
            self.tableViewCart.reloadData()
        }
        alert.addAction(delete)
        alert.addAction(cancel)
       
        present(alert, animated: true)
      
    }
    
    @IBAction func btnSwitch(_ sender: Any) {
        
    }
    
    @IBAction func btnCartConfirm_TUI(_ sender: Any) {
       
      
        if foods.count >= 1 {
            confirmLottieView.isHidden = false
            btnCartConfirm.titleLabel?.text = "Sepet Onaylandı"
            btnCartConfirm.backgroundColor = .gray
            self.cartConfirmAnimation()
        }
       
    }
    
   
}


     // MARK: - Extension

extension VC_CartPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = foods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! TableViewCell_Cart
        cell.labelFoodName.text = food.yemek_adi
        let newCount = Double(food.yemek_siparis_adet!)!
        let newPrice = Double(food.yemek_fiyat!)!
        priceCalculation = newCount * newPrice
        cell.labelPrice.text = "\(String(priceCalculation)) ₺"
        
        cell.labelFoodCount.text = String(food.yemek_siparis_adet!)
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.imageViewFood.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { contexttualAction, view, bool in
            let food = self.foods[indexPath.row]
            
            let alert = UIAlertController(title: "\(food.yemek_adi!) sepetinizden silinsin mi?", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel) { action in
                
                
            }
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Evet", style: .destructive) { action in
                self.cartPagePresenterObject?.delete(cart_food_id: food.sepet_yemek_id!)
                self.foods.remove(at: indexPath.row)
                self.tableViewCart.reloadData()
            }
            
            
            alert.addAction(yesAction)
            
            self.present(alert, animated: true)
            self.get_total()
            
        /*
            if let foodId = food.sepet_yemek_id {
                for id in foodId {
                    self.cartPagePresenterObject?.delete(cart_food_id: String(id))
                }
                self.foods.remove(at: indexPath.row)
                self.get_total()
                self.tableViewCart.reloadData()
            } */
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension VC_CartPage: PresenterToViewCartPageProtocol {
    
    func dataTransferToView(cartFoodsLists: Array<CartFood>) {
        self.foods = cartFoodsLists
        DispatchQueue.main.async {
            self.tableViewCart.reloadData()
            self.get_total()
        }
        var uniqueSepet = Set<String>()
        var filteredArray = [CartFood]()
        
        for food in cartFoodsLists {
            uniqueSepet.insert(food.yemek_adi!)
        }
        
        for uniqueName in uniqueSepet {
            let sameNames = cartFoodsLists.filter {
                $0.yemek_adi == uniqueName
            }
            var total = 0
            var price = 0
            var newFoodId: [String] = []
            for food in sameNames {
                total += Int(food.yemek_siparis_adet!)!
                newFoodId.append(food.sepet_yemek_id!)
                price += Int(food.yemek_fiyat!)!
                print("\(price) yemek fiyat")
            }
           // filteredArray.append(CartFoodResponse(sepet_yemek_id: foods.sepet_yemek_id, yemek_adi: <#T##String#>, yemek_resim_adi: <#T##String#>, yemek_fiyat: <#T##String#>, yemek_siparis_adet: <#T##String#>, kullanici_adi: <#T##String#>))
            if filteredArray.count > 0 {
                self.foods = filteredArray
            }
        }

        tableViewCart.reloadData()
    }
}
