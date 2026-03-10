//
//  FoodDetailViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Kingfisher
import UIKit

final class FoodDetailViewController: UIViewController {
    // MARK: - Properties
    var viewModel: FoodDetailViewModel!
    weak var coordinator: FoodDetailCoordinator?

    // MARK: - UI Properties
    private lazy var contentScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var foodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.titleFontSize
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var starRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.metaFontSize,
            weight: .medium
        )
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var prepareTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.metaFontSize,
            weight: .regular
        )
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var foodDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.descFontSize
        )
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var foodPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.priceFontSize
        )
        label.textColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var orderQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.quantityFontSize
        )
        label.text = Constant.Text.defaultQuantity
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: Constant.Image.minusCircle),
            for: .normal
        )
        button.tintColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: Constant.Image.plusCircle),
            for: .normal
        )
        button.tintColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            Constant.Text.addToCartTitle,
            for: .normal
        )
        button.titleLabel?.font = .boldSystemFont(
            ofSize: Constant.Layout.descFontSize
        )
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        button.layer.cornerRadius = Constant.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var horizontalStepperStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                decrementButton,
                orderQuantityLabel,
                incrementButton
            ]
        )
        stack.axis = .horizontal
        stack.spacing = Constant.Layout.smallPadding
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        viewModel.loadDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            false,
            animated: animated
        )
    }
}

// MARK: - UI Setup
private extension FoodDetailViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(foodImageView)
        scrollContentView.addSubview(foodNameLabel)
        scrollContentView.addSubview(starRatingLabel)
        scrollContentView.addSubview(prepareTimeLabel)
        scrollContentView.addSubview(foodDescriptionLabel)
        scrollContentView.addSubview(foodPriceLabel)
        scrollContentView.addSubview(horizontalStepperStackView)
        scrollContentView.addSubview(addToCartButton)

        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            contentScrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            contentScrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            contentScrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            scrollContentView.topAnchor.constraint(
                equalTo: contentScrollView.topAnchor
            ),
            scrollContentView.leadingAnchor.constraint(
                equalTo: contentScrollView.leadingAnchor
            ),
            scrollContentView.trailingAnchor.constraint(
                equalTo: contentScrollView.trailingAnchor
            ),
            scrollContentView.bottomAnchor.constraint(
                equalTo: contentScrollView.bottomAnchor
            ),
            scrollContentView.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            foodImageView.topAnchor.constraint(
                equalTo: scrollContentView.topAnchor
            ),
            foodImageView.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor
            ),
            foodImageView.trailingAnchor.constraint(
                equalTo: scrollContentView.trailingAnchor
            ),
            foodImageView.heightAnchor.constraint(
                equalToConstant: Constant.Layout.imageHeight
            ),
            foodNameLabel.topAnchor.constraint(
                equalTo: foodImageView.bottomAnchor,
                constant: Constant.Layout.padding
            ),
            foodNameLabel.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            foodNameLabel.trailingAnchor.constraint(
                equalTo: scrollContentView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            starRatingLabel.topAnchor.constraint(
                equalTo: foodNameLabel.bottomAnchor,
                constant: Constant.Layout.smallPadding
            ),
            starRatingLabel.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            prepareTimeLabel.centerYAnchor.constraint(
                equalTo: starRatingLabel.centerYAnchor
            ),
            prepareTimeLabel.leadingAnchor.constraint(
                equalTo: starRatingLabel.trailingAnchor,
                constant: Constant.Layout.padding
            ),
            foodDescriptionLabel.topAnchor.constraint(
                equalTo: starRatingLabel.bottomAnchor,
                constant: Constant.Layout.padding
            ),
            foodDescriptionLabel.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            foodDescriptionLabel.trailingAnchor.constraint(
                equalTo: scrollContentView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            foodPriceLabel.topAnchor.constraint(
                equalTo: foodDescriptionLabel.bottomAnchor,
                constant: Constant.Layout.padding
            ),
            foodPriceLabel.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            horizontalStepperStackView.centerYAnchor.constraint(
                equalTo: foodPriceLabel.centerYAnchor
            ),
            horizontalStepperStackView.trailingAnchor.constraint(
                equalTo: scrollContentView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            decrementButton.widthAnchor.constraint(
                equalToConstant: Constant.Layout.stepperSize
            ),
            decrementButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.stepperSize
            ),
            incrementButton.widthAnchor.constraint(
                equalToConstant: Constant.Layout.stepperSize
            ),
            incrementButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.stepperSize
            ),
            addToCartButton.topAnchor.constraint(
                equalTo: foodPriceLabel.bottomAnchor,
                constant: Constant.Layout.padding
            ),
            addToCartButton.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            addToCartButton.trailingAnchor.constraint(
                equalTo: scrollContentView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            addToCartButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.buttonHeight
            ),
            addToCartButton.bottomAnchor.constraint(
                equalTo: scrollContentView.bottomAnchor,
                constant: -Constant.Layout.padding
            )
        ])
    }

    func setupActions() {
        decrementButton.addTarget(
            self,
            action: #selector(decrementButtonTapped),
            for: .touchUpInside
        )
        incrementButton.addTarget(
            self,
            action: #selector(incrementButtonTapped),
            for: .touchUpInside
        )
        addToCartButton.addTarget(
            self,
            action: #selector(addToCartButtonTapped),
            for: .touchUpInside
        )
    }
}

// MARK: - Action Methods
private extension FoodDetailViewController {
    @objc func decrementButtonTapped() {
        viewModel.decrementQuantity()
    }

    @objc func incrementButtonTapped() {
        viewModel.incrementQuantity()
    }

    @objc func addToCartButtonTapped() {
        viewModel.addToCart()
    }
}

// MARK: - FoodDetailViewModelDelegate
extension FoodDetailViewController: FoodDetailViewModelDelegate {
    func didUpdateUI(
        name: String,
        priceText: String,
        imageURL: URL?,
        detail: FoodDetail?
    ) {
        foodNameLabel.text = name
        foodPriceLabel.text = priceText
        foodImageView.kf.setImage(with: imageURL)
        if let detail {
            starRatingLabel.text = "⭐ \(detail.starRating)"
            prepareTimeLabel.text = "🕐 \(detail.prepareTime)"
            foodDescriptionLabel.text = detail.description
        }
    }

    func didUpdateQuantity(
        _ quantity: Int,
        priceText: String
    ) {
        orderQuantityLabel.text = "\(quantity)"
        foodPriceLabel.text = priceText
    }

    func didAddToCart() {
        let alert = UIAlertController(
            title: nil,
            message: Constant.Text.addedToCartMessage,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: Constant.Text.continueAction,
                style: .default
            )
        )
        alert.addAction(
            UIAlertAction(
                title: Constant.Text.goToCartAction,
                style: .cancel
            ) { [weak self] _ in
                self?.coordinator?.didFinish()
                self?.tabBarController?.selectedIndex = 2
            }
        )
        present(alert, animated: true)
    }

    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(
            title: Constant.Text.errorTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: Constant.Text.okAction,
                style: .default
            )
        )
        present(alert, animated: true)
    }
}

// MARK: - Constants
extension FoodDetailViewController {
    enum Constant {
        enum Layout {
            static let imageHeight: CGFloat = 280
            static let padding: CGFloat = 20
            static let smallPadding: CGFloat = 8
            static let cornerRadius: CGFloat = 16
            static let buttonHeight: CGFloat = 50
            static let stepperSize: CGFloat = 36
            static let titleFontSize: CGFloat = 24
            static let priceFontSize: CGFloat = 22
            static let descFontSize: CGFloat = 15
            static let metaFontSize: CGFloat = 14
            static let quantityFontSize: CGFloat = 18
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
            static let minusCircle = "minus.circle.fill"
            static let plusCircle = "plus.circle.fill"
        }

        enum Text {
            static let defaultQuantity = "1"
            static let addToCartTitle = "Sepete Ekle"
            static let addedToCartMessage = "Ürünler sepete eklendi."
            static let continueAction = "Devam Et"
            static let goToCartAction = "Sepete Git"
            static let errorTitle = "Hata"
            static let okAction = "Tamam"
        }
    }
}
