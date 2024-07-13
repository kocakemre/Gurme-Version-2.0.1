//
//  HomePageVC.swift
//  Gurme
//
//  Created by Emre Kocak on 24.09.2022.
//

import UIKit
import Kingfisher

final class HomePageVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet private weak var collectionViewSlider: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var colletionViewFoods: UICollectionView!
    @IBOutlet private weak var searchBarText: UISearchBar!
    @IBOutlet private weak var btnNotification: UIButton!
    
    var arraySliderPhotos = [UIImage(named: "sliderGurme-1"),
                             UIImage(named: "sliderGurme-2"),
                             UIImage(named: "sliderGurme-3"),
                             UIImage(named: "sliderGurme-4"),
                             UIImage(named: "sliderGurme-5"),
                             UIImage(named: "sliderGurme-6")]
    
    private var timer: Timer?
    private var currentCellIndex = 0
    
    weak var homePagePresenterObject: ViewToPresenterHomePageProtocol?
    private var foodsList = [AllFood]()
    private var filteredFoodList = [AllFood]()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNotification.titleLabel?.text = ""
        // Slider
        collectionViewSlider.delegate = self
        collectionViewSlider.dataSource = self
        // Foods
        colletionViewFoods.delegate = self
        colletionViewFoods.dataSource = self
        // Search
        searchBarText.delegate = self
        HomePageRouter.createModule(ref: self)
        
        pageControl.numberOfPages = arraySliderPhotos.count
        self.startTimer()
        
        // Products collectionView size settings
        
        homePagePresenterObject?.allFoods()
        
        let desing = UICollectionViewFlowLayout()
        desing.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //desing.minimumLineSpacing = 10
        //desing.minimumInteritemSpacing = 10
        let width = colletionViewFoods.frame.size.width
        let cellWidth = (width - 10) / 3
        desing.itemSize = CGSize(width: cellWidth, height: cellWidth)
        colletionViewFoods.collectionViewLayout = desing
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnNotification.titleLabel?.text = ""
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.btnNotification.titleLabel?.text = ""
    }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "sgDetail" else { return }
        
        let food = sender as? AllFood
        let pushToVC = segue.destination as? FoodDetailPageVC
        pushToVC?.products = food
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 2.5,
            target: self,
            selector: #selector(moveToNextIndex),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func moveToNextIndex() {
        
        if currentCellIndex < arraySliderPhotos.count - 1 {
            currentCellIndex += 1
        } else {
            currentCellIndex = 0
        }
        
        collectionViewSlider.scrollToItem(
            at: IndexPath(
                item: currentCellIndex,
                section: 0
            ),
            at: .centeredHorizontally,
            animated: true
        )
        pageControl.currentPage = currentCellIndex
    }
    
    // MARK: - UI Elements
    @IBAction func btnNotification_TUI(_ sender: Any) {
        
        let alert = UIAlertController(
            title: "Uyarı",
            message: "Herhangi bir bildiriminiz bulunmamaktadır.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Tamam", style: .default)
        
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource - Foods - Slider

extension HomePageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        switch collectionView {
            
        case collectionViewSlider:
            return arraySliderPhotos.count
            
        case colletionViewFoods:
            return foodsList.count
            
        default:
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
            
        case collectionViewSlider:
            guard  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "homeCell",
                for: indexPath
            ) as? CollectionViewCell_Slider else { return UICollectionViewCell() }
            
            cell.imageViewSliderFood.image = arraySliderPhotos[indexPath.row]
            
            return cell
            
        case colletionViewFoods:
            
            let food = foodsList[indexPath.row]
            let baseUrl = "http://kasimadalan.pe.hu/yemekler/resimler/"
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "foodCell",
                for: indexPath
            ) as? CollectionViewCell_Foods else { return UICollectionViewCell() }
            
            cell.imageViewFood.image = UIImage(systemName: "photo")
            
            if let url = URL(string: "\(baseUrl)\(food.yemek_resim_adi ?? "")") {
                DispatchQueue.main.async {
                    cell.imageViewFood.kf.setImage(with: url)
                }
            }
            
            cell.labelName.text = food.yemek_adi
            cell.labelPrice.text = "₺ \(food.yemek_fiyat ?? "")"
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let food = filteredFoodList[indexPath.row]
        performSegue(withIdentifier: "sgDetail", sender: food)
        CollectionViewCell_Foods.productInfo = ProductDetailsList.productList[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        switch collectionView {
            
        case collectionViewSlider:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case colletionViewFoods:
            let yourWidth = collectionView.bounds.width / 3.0
            let yourHeight = yourWidth * 1.5
            
            return CGSize(width: yourWidth, height: yourHeight)
        default:
            return CGSize()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomePageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        switch collectionView {
            
        case collectionViewSlider, colletionViewFoods:
            return 0
            
        default:
            return CGFloat()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        switch collectionView {
            
        case collectionViewSlider, colletionViewFoods:
            return 0
            
        default:
            return CGFloat()
        }
    }
}

// MARK: - Extension Protocol: Data transfer from BasketPresenter

extension HomePageVC: PresenterToViewHomePageProtocol {
    
    func dataTransferToView(foodList: Array<AllFood>) {
        self.foodsList = foodList
        self.filteredFoodList = foodList
        self.colletionViewFoods.reloadData()
    }
}

// MARK: - Extension Search
extension HomePageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        foodsList = filteredFoodList.filter {
            if searchText.count != 0, let foodName = $0.yemek_adi {
                return foodName.lowercased().contains(searchText.lowercased())
            }
            return true
        }
        
        colletionViewFoods.reloadData()
    }
}
