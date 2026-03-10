//
//  HomeViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class HomeViewController: UIViewController, AlertShowable {
    // MARK: - Section & Item
    enum Section: Int, CaseIterable {
        case slider
        case foods
    }

    enum Item: Hashable {
        case slider(SliderItem)
        case food(Food)
    }

    // MARK: - Properties
    var viewModel: HomeViewModel!
    weak var coordinator: HomeCoordinator?
    private var autoScrollTimer: Timer?
    private var currentSliderPage = 0

    // MARK: - UI Properties
    private var foodCollectionView: UICollectionView!
    private var foodDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private lazy var sliderPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = viewModel.sliderCount
        pageControl.currentPageIndicatorTintColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.isUserInteractionEnabled = false
        pageControl.backgroundStyle = .minimal
        return pageControl
    }()
    private lazy var foodSearchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: nil
        )
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constant.Text.searchPlaceholder
        return searchController
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        viewModel.fetchFoods()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            false,
            animated: animated
        )
        startAutoScrollTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScrollTimer()
    }

    // MARK: - Scroll to Top (Tab Bar re-tap)
    func scrollToTop() {
        guard foodCollectionView.numberOfSections > 0 else { return }
        foodCollectionView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - UI Setup
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constant.Text.title
        setupCollectionView()
        setupPageControl()
        configureSearchController()
    }

    func setupCollectionView() {
        foodCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        foodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        foodCollectionView.backgroundColor = .systemBackground
        foodCollectionView.delegate = self
        foodCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(foodCollectionView)
        NSLayoutConstraint.activate([
            foodCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            foodCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            foodCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            foodCollectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }

    func setupPageControl() {
        foodCollectionView.addSubview(sliderPageControl)
        NSLayoutConstraint.activate([
            sliderPageControl.centerXAnchor.constraint(
                equalTo: foodCollectionView.centerXAnchor
            ),
            sliderPageControl.topAnchor.constraint(
                equalTo: foodCollectionView.topAnchor,
                constant: Constant.Layout.sliderHeight
                    - Constant.Layout.pageControlHeight
            ),
            sliderPageControl.heightAnchor.constraint(
                equalToConstant: Constant.Layout.pageControlHeight
            )
        ])
    }

    func configureSearchController() {
        navigationItem.searchController = foodSearchController
        definesPresentationContext = true
    }
}

// MARK: - Auto-Scroll Timer
private extension HomeViewController {
    func startAutoScrollTimer() {
        stopAutoScrollTimer()
        autoScrollTimer = Timer.scheduledTimer(
            withTimeInterval: Constant.Layout.autoScrollInterval,
            repeats: true
        ) { [weak self] _ in
            self?.scrollToNextSlider()
        }
    }

    func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    func scrollToNextSlider() {
        let totalPages = viewModel.sliderCount
        guard totalPages > 0 else { return }
        currentSliderPage = (currentSliderPage + 1) % totalPages
        let indexPath = IndexPath(
            item: currentSliderPage,
            section: Section.slider.rawValue
        )
        foodCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        sliderPageControl.currentPage = currentSliderPage
    }
}

// MARK: - Compositional Layout
private extension HomeViewController {
    func createCompositionalLayout()
        -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, environment in
            guard let section = Section(
                rawValue: sectionIndex
            ) else {
                return nil
            }
            switch section {
            case .slider:
                return self?.createSliderSection()
            case .foods:
                return self?.createFoodsSection(
                    environment: environment
                )
            }
        }
    }

    func createSliderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Layout.sliderSideInset,
            bottom: 0,
            trailing: Constant.Layout.sliderSideInset
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Layout.sliderHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: Constant.Layout.sliderBottomInset,
            trailing: 0
        )
        section.visibleItemsInvalidationHandler = {
            [weak self] _, offset, environment in
            let width = environment.container.contentSize.width
            guard width > 0 else { return }
            let page = Int(round(offset.x / width))
            DispatchQueue.main.async {
                self?.sliderPageControl.currentPage = page
                self?.currentSliderPage = page
            }
        }
        return section
    }

    func createFoodsSection(
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(
                Constant.Layout.foodEstimatedHeight
            )
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.Layout.foodItemInset,
            leading: Constant.Layout.foodItemInset,
            bottom: Constant.Layout.foodItemInset,
            trailing: Constant.Layout.foodItemInset
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(
                Constant.Layout.foodEstimatedHeight
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Constant.Layout.columnsCount
        )
        group.interItemSpacing = .fixed(
            Constant.Layout.foodItemInset
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.Layout.foodInterGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.Layout.sectionTopInset,
            leading: Constant.Layout.sectionSideInset,
            bottom: Constant.Layout.sectionBottomInset,
            trailing: Constant.Layout.sectionSideInset
        )
        return section
    }
}

// MARK: - DiffableDataSource
private extension HomeViewController {
    func configureDataSource() {
        let sliderRegistration = UICollectionView.CellRegistration
        <SliderCell, SliderItem> { cell, _, sliderItem in
            cell.configure(with: sliderItem)
        }
        let foodRegistration = UICollectionView.CellRegistration
        <FoodCell, Food> { [weak self] cell, _, food in
            guard let self else { return }
            let isFavorited = self.viewModel.isFavorite(food)
            cell.configure(
                with: food,
                isFavorited: isFavorited
            )
            cell.onFavoriteTapped = { [weak self] in
                self?.viewModel.toggleFavorite(for: food)
            }
        }
        foodDataSource = UICollectionViewDiffableDataSource<
            Section, Item
        >(collectionView: foodCollectionView) {
            collectionView, indexPath, item in
            switch item {
            case .slider(let sliderItem):
                return collectionView.dequeueConfiguredReusableCell(
                    using: sliderRegistration,
                    for: indexPath,
                    item: sliderItem
                )
            case .food(let food):
                return collectionView.dequeueConfiguredReusableCell(
                    using: foodRegistration,
                    for: indexPath,
                    item: food
                )
            }
        }
    }

    func applySnapshot(isAnimated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<
            Section, Item
        >()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(
            viewModel.sliderItems.map { .slider($0) },
            toSection: .slider
        )
        snapshot.appendItems(
            viewModel.filteredFoods.map { .food($0) },
            toSection: .foods
        )
        foodDataSource.apply(
            snapshot,
            animatingDifferences: isAnimated
        )
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )
        guard let item = foodDataSource.itemIdentifier(
            for: indexPath
        ) else { return }
        if case .food(let food) = item {
            coordinator?.showFoodDetail(food: food)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(
        for searchController: UISearchController
    ) {
        let query = searchController.searchBar.text ?? ""
        viewModel.searchFoods(query: query)
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didUpdateFoods() {
        guard isViewLoaded else { return }
        applySnapshot()
    }

    func didUpdateFavoriteState() {
        guard isViewLoaded else { return }
        var snapshot = foodDataSource.snapshot()
        let foodItems = snapshot.itemIdentifiers(inSection: .foods)
        snapshot.reconfigureItems(foodItems)
        foodDataSource.apply(snapshot, animatingDifferences: false)
    }

    func didFailWithError(_ error: Error) {
        showAlert(arguments: AlertArguments(
            title: Constant.Text.errorTitle,
            message: error.localizedDescription,
            buttonTitle: Constant.Text.okAction
        ))
    }
}

// MARK: - Constants
extension HomeViewController {
    enum Constant {
        enum Layout {
            static let sliderHeight: CGFloat = 200
            static let sliderCornerRadius: CGFloat = 16
            static let sliderSideInset: CGFloat = 12
            static let sliderBottomInset: CGFloat = 4
            static let foodEstimatedHeight: CGFloat = 230
            static let foodItemInset: CGFloat = 6
            static let foodInterGroupSpacing: CGFloat = 12
            static let sectionTopInset: CGFloat = 16
            static let sectionBottomInset: CGFloat = 16
            static let sectionSideInset: CGFloat = 10
            static let columnsCount = 2
            static let pageControlHeight: CGFloat = 28
            static let autoScrollInterval: TimeInterval = 3.5
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
        }

        enum Text {
            static let title = "Gurme"
            static let searchPlaceholder = "Yemek ara..."
            static let errorTitle = "Hata"
            static let okAction = "Tamam"
        }
    }
}
