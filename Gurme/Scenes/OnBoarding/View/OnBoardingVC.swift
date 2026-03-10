//
//  OnBoardingVC.swift
//  Gurme
//
//  Created by Emre Kocak on 25.09.2022.
//

import UIKit

final class OnBoardingVC: UIViewController {

    // MARK: - UI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        // Register before assigning delegate/dataSource to avoid any layout-pass
        // race condition where the collection view requests cells before registration.
        cv.register(
            OnBoardingCell.self,
            forCellWithReuseIdentifier: OnBoardingCell.identifierCell
        )
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    // MARK: - Properties
    var onComplete: (() -> Void)?
    private var slides: [OnBoardingSlide] = []
    private var currentPage = 0

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlideContent()
        setupUI()
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        slides.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnBoardingCell.identifierCell,
            for: indexPath
        ) as? OnBoardingCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(slides[indexPath.row])
        cell.btnActionTap = { [weak self] in
            self?.handleActionBtnTapped(at: indexPath)
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage
    }
}

// MARK: - Setup
private extension OnBoardingVC {

    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(pageControl)

        pageControl.numberOfPages = slides.count

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            )
        ])
    }

    func setupSlideContent() {
        slides = [
            .init(
                titleHead: "Hey Gurme, Uygulamana Hoşgeldin!",
                titleChild: "Uygun fiyatlı Gurme yemekleri keşfedip en hızlı şekilde alabileceğin Gurme uygulamasını hemen kullanmaya başla!",
                animationName: "order",
                btnColor: UIColor(named: "OrderSkipBtn")!,
                btnTitle: "İleri"
            ),
            .init(
                titleHead: "Hemen Keşfet!",
                titleChild: "Binlerce çeşit gurme yemekleri anında keşfet!",
                animationName: "orderFood",
                btnColor: UIColor(named: "OrderFoodSkipBtn")!,
                btnTitle: "İleri"
            ),
            .init(
                titleHead: "Çok Kısa Sürede Kapında!",
                titleChild: "Güler yüzlü Gurme kuryelerle yemeğiniz kısa sürede kapınızda.",
                animationName: "deliveryGuyOrder",
                btnColor: UIColor(named: "courierSkipBtn")!,
                btnTitle: "İleri"
            ),
            .init(
                titleHead: "Hem leziz Hem İndirimli!",
                titleChild: "Sana özel kampanyaları hemen keşfet!",
                animationName: "discount",
                btnColor: UIColor(named: "OnBoardingGoBtn")!,
                btnTitle: "Başla!"
            )
        ]
    }

    func handleActionBtnTapped(at indexPath: IndexPath) {
        if indexPath.item == slides.count - 1 {
            onComplete?()
        } else {
            let nextIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            currentPage = nextIndexPath.item
            pageControl.currentPage = currentPage
        }
    }
}
