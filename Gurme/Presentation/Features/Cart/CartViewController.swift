//
//  CartViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Lottie
import UIKit

final class CartViewController: UIViewController, AlertShowable {
    // MARK: - Properties
    var viewModel: CartViewModel!
    weak var coordinator: CartCoordinator?

    // MARK: - UI Properties
    private var cartCollectionView: UICollectionView!
    private var cartDataSource: UICollectionViewDiffableDataSource<Int, CartItem>!

    private lazy var bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.priceFontSize
        )
        label.text = Constant.Text.defaultTotal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            Constant.Text.confirmButtonTitle,
            for: .normal
        )
        button.titleLabel?.font = .boldSystemFont(
            ofSize: Constant.Layout.buttonFontSize
        )
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        button.layer.cornerRadius = Constant.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emptyAnimationView: AnimationView = {
        let animationView = AnimationView()
        animationView.animation = Animation.named(Constant.Animation.emptyCart)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    private lazy var emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.emptyCartTitle
        label.font = .boldSystemFont(ofSize: Constant.Layout.emptyTitleFontSize)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.emptyCartSubtitle
        label.font = .systemFont(ofSize: Constant.Layout.emptySubtitleFontSize)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var shopNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constant.Text.shopNowTitle, for: .normal)
        button.titleLabel?.font = .boldSystemFont(
            ofSize: Constant.Layout.buttonFontSize
        )
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        button.layer.cornerRadius = Constant.Layout.shopNowCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCart()
    }
}

// MARK: - UI Setup
private extension CartViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constant.Text.title
        setupNavigationBar()
        setupBottomBar()
        setupCollectionView()
        setupEmptyStateView()
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constant.Image.trash),
            style: .plain,
            target: self,
            action: #selector(trashButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }

    func setupCollectionView() {
        var config = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        config.trailingSwipeActionsConfigurationProvider = {
            [weak self] indexPath in
            self?.swipeActions(for: indexPath)
        }
        let layout = UICollectionViewCompositionalLayout.list(
            using: config
        )
        cartCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        cartCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cartCollectionView)
        NSLayoutConstraint.activate([
            cartCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            cartCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            cartCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            cartCollectionView.bottomAnchor.constraint(
                equalTo: bottomBarView.topAnchor
            )
        ])
    }

    func setupBottomBar() {
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(totalPriceLabel)
        bottomBarView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            bottomBarView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            bottomBarView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            bottomBarView.heightAnchor.constraint(
                equalToConstant: Constant.Layout.bottomBarHeight
            ),
            totalPriceLabel.leadingAnchor.constraint(
                equalTo: bottomBarView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            totalPriceLabel.centerYAnchor.constraint(
                equalTo: bottomBarView.centerYAnchor
            ),
            confirmButton.trailingAnchor.constraint(
                equalTo: bottomBarView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            confirmButton.centerYAnchor.constraint(
                equalTo: bottomBarView.centerYAnchor
            ),
            confirmButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.buttonHeight
            ),
            confirmButton.leadingAnchor.constraint(
                equalTo: totalPriceLabel.trailingAnchor,
                constant: Constant.Layout.padding
            )
        ])
    }

    func setupActions() {
        confirmButton.addTarget(
            self,
            action: #selector(confirmButtonTapped),
            for: .touchUpInside
        )
        shopNowButton.addTarget(
            self,
            action: #selector(shopNowButtonTapped),
            for: .touchUpInside
        )
    }

    func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyAnimationView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
        emptyStateView.addSubview(shopNowButton)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            emptyStateView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            emptyStateView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            emptyStateView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            emptyAnimationView.centerXAnchor.constraint(
                equalTo: emptyStateView.centerXAnchor
            ),
            emptyAnimationView.centerYAnchor.constraint(
                equalTo: emptyStateView.centerYAnchor,
                constant: -Constant.Layout.animationCenterYOffset
            ),
            emptyAnimationView.widthAnchor.constraint(
                equalToConstant: Constant.Layout.emptyAnimationSize
            ),
            emptyAnimationView.heightAnchor.constraint(
                equalToConstant: Constant.Layout.emptyAnimationSize
            ),
            emptyTitleLabel.topAnchor.constraint(
                equalTo: emptyAnimationView.bottomAnchor,
                constant: Constant.Layout.titleSpacing
            ),
            emptyTitleLabel.leadingAnchor.constraint(
                equalTo: emptyStateView.leadingAnchor,
                constant: Constant.Layout.shopNowHorizontalPadding
            ),
            emptyTitleLabel.trailingAnchor.constraint(
                equalTo: emptyStateView.trailingAnchor,
                constant: -Constant.Layout.shopNowHorizontalPadding
            ),
            emptySubtitleLabel.topAnchor.constraint(
                equalTo: emptyTitleLabel.bottomAnchor,
                constant: Constant.Layout.subtitleSpacing
            ),
            emptySubtitleLabel.leadingAnchor.constraint(
                equalTo: emptyStateView.leadingAnchor,
                constant: Constant.Layout.shopNowHorizontalPadding
            ),
            emptySubtitleLabel.trailingAnchor.constraint(
                equalTo: emptyStateView.trailingAnchor,
                constant: -Constant.Layout.shopNowHorizontalPadding
            ),
            shopNowButton.leadingAnchor.constraint(
                equalTo: emptyStateView.leadingAnchor,
                constant: Constant.Layout.shopNowHorizontalPadding
            ),
            shopNowButton.trailingAnchor.constraint(
                equalTo: emptyStateView.trailingAnchor,
                constant: -Constant.Layout.shopNowHorizontalPadding
            ),
            shopNowButton.bottomAnchor.constraint(
                equalTo: emptyStateView.bottomAnchor,
                constant: -Constant.Layout.shopNowBottomPadding
            ),
            shopNowButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.shopNowButtonHeight
            )
        ])
    }

    func updateEmptyState() {
        let isEmpty = viewModel.isEmpty
        emptyStateView.isHidden = !isEmpty
        cartCollectionView.isHidden = isEmpty
        bottomBarView.isHidden = isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
        if isEmpty {
            emptyAnimationView.play()
        } else {
            emptyAnimationView.stop()
        }
    }

    func swipeActions(
        for indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Constant.Text.deleteAction
        ) { [weak self] _, _, completion in
            self?.viewModel.deleteItem(at: indexPath.item)
            completion(true)
        }
        return UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
    }
}

// MARK: - Action Methods
private extension CartViewController {
    @objc func shopNowButtonTapped() {
        coordinator?.showHome()
    }

    @objc func trashButtonTapped() {
        let alert = UIAlertController(
            title: Constant.Text.warningTitle,
            message: Constant.Text.deleteAllMessage,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: Constant.Text.cancelAction,
                style: .cancel
            )
        )
        alert.addAction(
            UIAlertAction(
                title: Constant.Text.deleteAction,
                style: .destructive
            ) { [weak self] _ in
                self?.viewModel.deleteAllItems()
            }
        )
        present(alert, animated: true)
    }

    @objc func confirmButtonTapped() {
        viewModel.confirmOrder()
    }
}

// MARK: - DiffableDataSource
private extension CartViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <CartItemCell, CartItem> { cell, _, cartItem in
            cell.configure(with: cartItem)
        }
        cartDataSource = UICollectionViewDiffableDataSource<
            Int, CartItem
        >(collectionView: cartCollectionView) {
            collectionView, indexPath, cartItem in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: cartItem
            )
        }
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<
            Int, CartItem
        >()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.cartItems)
        cartDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - CartViewModelDelegate
extension CartViewController: CartViewModelDelegate {
    func didUpdateCart() {
        applySnapshot()
        updateEmptyState()
    }

    func didUpdateTotalPrice(_ totalText: String) {
        totalPriceLabel.text = totalText
    }

    func didConfirmOrder() {
        showAlert(arguments: AlertArguments(
            title: Constant.Text.successTitle,
            message: Constant.Text.orderConfirmedMessage,
            buttonTitle: Constant.Text.okAction
        ))
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
extension CartViewController {
    enum Constant {
        enum Layout {
            static let bottomBarHeight: CGFloat = 80
            static let buttonHeight: CGFloat = 48
            static let padding: CGFloat = 16
            static let cornerRadius: CGFloat = 12
            static let priceFontSize: CGFloat = 18
            static let buttonFontSize: CGFloat = 16
            static let emptyAnimationSize: CGFloat = 220
            static let animationCenterYOffset: CGFloat = 80
            static let emptyTitleFontSize: CGFloat = 22
            static let emptySubtitleFontSize: CGFloat = 15
            static let titleSpacing: CGFloat = 16
            static let subtitleSpacing: CGFloat = 8
            static let shopNowButtonHeight: CGFloat = 52
            static let shopNowCornerRadius: CGFloat = 26
            static let shopNowHorizontalPadding: CGFloat = 32
            static let shopNowBottomPadding: CGFloat = 24
        }

        enum Animation {
            static let emptyCart = "orderFood"
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
            static let trash = "trash"
        }

        enum Text {
            static let title = "Sepetim"
            static let defaultTotal = "TOTAL: 0 TL"
            static let confirmButtonTitle = "Sepeti Onayla"
            static let deleteAction = "Sil"
            static let cancelAction = "Vazgeç"
            static let warningTitle = "Uyarı"
            static let deleteAllMessage =
                "Sepetinizdeki tüm ürünler silinsin mi?"
            static let successTitle = "Başarılı"
            static let orderConfirmedMessage = "Sepetiniz onaylandı!"
            static let errorTitle = "Hata"
            static let okAction = "Tamam"
            static let emptyCartTitle = "Sepetiniz Boş"
            static let emptyCartSubtitle = "Sepetinde ürün bulunmamaktadır.\nHemen alışverişe başla!"
            static let shopNowTitle = "Alışverişe Başla"
        }
    }
}
