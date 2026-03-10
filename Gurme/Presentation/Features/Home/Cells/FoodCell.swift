//
//  FoodCell.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Kingfisher
import UIKit

final class FoodCell: UICollectionViewCell {
    // MARK: - Callback
    var onFavoriteTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var foodContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Constant.Layout.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = Constant.Layout.shadowOpacity
        view.layer.shadowRadius = Constant.Layout.shadowRadius
        view.layer.shadowOffset = CGSize(
            width: 0,
            height: Constant.Layout.shadowOffsetHeight
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.Layout.cornerRadius
        imageView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.nameFontSize,
            weight: .medium
        )
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var foodPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.priceFontSize
        )
        label.textColor = UIColor(named: Constant.Image.mainOrangeColor)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        foodImageView.kf.cancelDownloadTask()
        foodImageView.image = nil
        foodNameLabel.text = nil
        foodPriceLabel.text = nil
        onFavoriteTapped = nil
    }

    // MARK: - Configure
    func configure(with food: Food, isFavorited: Bool) {
        foodNameLabel.text = food.name
        foodPriceLabel.text = "\(food.price) \(Constant.Text.currencySymbol)"
        foodImageView.kf.setImage(with: food.imageURL)
        let heartImage = isFavorited
            ? Constant.Image.heartFill
            : Constant.Image.heart
        favoriteButton.setImage(
            UIImage(systemName: heartImage),
            for: .normal
        )
    }
}

// MARK: - UI Setup
private extension FoodCell {
    func setupUI() {
        contentView.addSubview(foodContainerView)
        foodContainerView.addSubview(foodImageView)
        foodContainerView.addSubview(foodNameLabel)
        foodContainerView.addSubview(foodPriceLabel)
        foodContainerView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            foodContainerView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            foodContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            foodContainerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            foodContainerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            foodImageView.topAnchor.constraint(
                equalTo: foodContainerView.topAnchor
            ),
            foodImageView.leadingAnchor.constraint(
                equalTo: foodContainerView.leadingAnchor
            ),
            foodImageView.trailingAnchor.constraint(
                equalTo: foodContainerView.trailingAnchor
            ),
            foodImageView.heightAnchor.constraint(
                equalToConstant: Constant.Layout.imageHeight
            ),
            foodNameLabel.topAnchor.constraint(
                equalTo: foodImageView.bottomAnchor,
                constant: Constant.Layout.padding
            ),
            foodNameLabel.leadingAnchor.constraint(
                equalTo: foodContainerView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            foodNameLabel.trailingAnchor.constraint(
                equalTo: foodContainerView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            foodPriceLabel.topAnchor.constraint(
                equalTo: foodNameLabel.bottomAnchor,
                constant: Constant.Layout.padding / 2
            ),
            foodPriceLabel.leadingAnchor.constraint(
                equalTo: foodContainerView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            foodPriceLabel.trailingAnchor.constraint(
                equalTo: foodContainerView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            foodPriceLabel.bottomAnchor.constraint(
                equalTo: foodContainerView.bottomAnchor,
                constant: -Constant.Layout.padding
            ),
            favoriteButton.topAnchor.constraint(
                equalTo: foodContainerView.topAnchor,
                constant: Constant.Layout.favoriteInset
            ),
            favoriteButton.trailingAnchor.constraint(
                equalTo: foodContainerView.trailingAnchor,
                constant: -Constant.Layout.favoriteInset
            ),
            favoriteButton.widthAnchor.constraint(
                equalToConstant: Constant.Layout.favoriteSize
            ),
            favoriteButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.favoriteSize
            )
        ])
    }

    func setupActions() {
        favoriteButton.addTarget(
            self,
            action: #selector(favoriteButtonTapped),
            for: .touchUpInside
        )
    }

    @objc func favoriteButtonTapped() {
        onFavoriteTapped?()
    }
}

// MARK: - Constants
extension FoodCell {
    enum Constant {
        enum Layout {
            static let cornerRadius: CGFloat = 12
            static let imageHeight: CGFloat = 120
            static let padding: CGFloat = 8
            static let favoriteSize: CGFloat = 28
            static let favoriteInset: CGFloat = 6
            static let shadowOpacity: Float = 0.1
            static let shadowRadius: CGFloat = 4
            static let shadowOffsetHeight: CGFloat = 2
            static let priceFontSize: CGFloat = 14
            static let nameFontSize: CGFloat = 13
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
            static let heart = "heart"
            static let heartFill = "heart.fill"
        }

        enum Text {
            static let currencySymbol = "₺"
        }
    }
}
