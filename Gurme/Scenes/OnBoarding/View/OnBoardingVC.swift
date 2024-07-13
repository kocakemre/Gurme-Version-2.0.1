//
//  OnBoardingVC.swift
//  Gurme
//
//  Created by Emre Kocak on 25.09.2022.
//

import UIKit

final class OnBoardingVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var welcome = true
    var slides: [OnBoardingSlide] = []
    var currentPage = 0
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionView()
        setupSlideContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if welcome {
            performSegue(withIdentifier: "sgSplashVC", sender: nil)
            welcome = false
        }
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return slides.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell_OnBoarding.identifierCell,
            for: indexPath
        ) as? CollectionViewCell_OnBoarding else {
            return UICollectionViewCell()
        }
        
        let slide = slides[indexPath.row]
        cell.configureCell(slide)
        cell.btnActionTap = {[weak self] in
            // for, when btn is tapped its understand in which indexPath
            self?.handleActionBtnTapped(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // for pageControl understand to scroll and change pageControl
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}

// MARK: - Methods
extension OnBoardingVC {
    
    func setupSlideContent() {
        slides = [
            .init(
                titleHead: "Hey Gurme, Uygulamana Hoşgeldin!",
                titleChild: "Uygun fiyatlı Gurme yemekleri keşfedip en hızlı şekilde alabileceğin Gurme uygulamasını hemen kullanmaya başla!",
                animationName: "order",
                btnColor: UIColor(
                    named: "OrderSkipBtn"
                )!,
                btnTitle: "İleri"
            ),
            .init(
                titleHead: "Hemen Keşfet!",
                titleChild: "Binlerce çeşit gurme yemekleri anında keşfet!",
                animationName: "orderFood",
                btnColor: UIColor(
                    named: "OrderFoodSkipBtn"
                )!,
                btnTitle: "İleri"
            ),
            .init(
                titleHead: "Çok Kısa Sürede Kapında!",
                titleChild: "Güler yüzlü Gurme kuryelerle yemeğiniz kısa sürede kapınızda.",
                animationName: "deliveryGuyOrder",
                btnColor: UIColor(
                    named: "courierSkipBtn"
                )!,
                btnTitle: "İleri"
            ),
            .init(
                titleHead: "Hem leziz Hem İndirimli!",
                titleChild: "Sana özel kampanyaları hemen keşfet!",
                animationName: "discount",
                btnColor: UIColor(
                    named: "OnBoardingGoBtn"
                )!,
                btnTitle: "Başla!"
            )
        ]
    }
    
    private func setupCollectionView() {
        collectionView.register(
            UINib(
                nibName: "CollectionViewCell_OnBoarding",
                bundle: .main
            ),
            forCellWithReuseIdentifier: CollectionViewCell_OnBoarding.identifierCell
        )
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
    }
    
    private func handleActionBtnTapped(at indexPath:IndexPath){
        if indexPath.item == slides.count - 1 {
            // we are on the last slide
            showWelcomePage()
        }else {
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
            pageControl.currentPage = nextItem
        }
    }
    
    private func showWelcomePage(){
        let controller = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "navigationController"
        )
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        present(controller, animated: true, completion: nil)
    }
}
