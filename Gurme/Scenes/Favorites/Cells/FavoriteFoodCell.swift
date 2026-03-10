//
//  FavoriteFoodCell.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Kingfisher
import UIKit

final class FavoriteFoodCell: UICollectionViewCell {
    // MARK: - UI Properties
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.Layout.cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.nameFontSize,
            weight: .semibold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var foodPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.priceFontSize,
            weight: .regular
        )
        label.textColor = UIColor(named: Constant.Image.mainOrangeColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var heartIconImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: Constant.Image.heartFill)
        )
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
    }

    // MARK: - Configure
    func configure(with food: Food) {
        foodNameLabel.text = food.name
        foodPriceLabel.text = "\(food.price) \(Constant.Text.currencySymbol)"
        foodImageView.kf.setImage(with: food.imageURL)
    }
}

// MARK: - UI Setup
private extension FavoriteFoodCell {
    func setupUI() {
        let verticalTextStackView = UIStackView(
            arrangedSubviews: [foodNameLabel, foodPriceLabel]
        )
        verticalTextStackView.axis = .vertical
        verticalTextStackView.spacing = Constant.Layout.stackSpacing
        verticalTextStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(foodImageView)
        contentView.addSubview(verticalTextStackView)
        contentView.addSubview(heartIconImageView)

        let iconSize = Constant.Layout.nameFontSize
        NSLayoutConstraint.activate([
            foodImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            foodImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            foodImageView.widthAnchor.constraint(
                equalToConstant: Constant.Layout.imageSize
            ),
            foodImageView.heightAnchor.constraint(
                equalToConstant: Constant.Layout.imageSize
            ),
            foodImageView.topAnchor.constraint(
                greaterThanOrEqualTo: contentView.topAnchor,
                constant: Constant.Layout.padding
            ),
            foodImageView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -Constant.Layout.padding
            ),
            verticalTextStackView.leadingAnchor.constraint(
                equalTo: foodImageView.trailingAnchor,
                constant: Constant.Layout.padding
            ),
            verticalTextStackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            verticalTextStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: heartIconImageView.leadingAnchor,
                constant: -Constant.Layout.padding
            ),
            heartIconImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            heartIconImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            heartIconImageView.widthAnchor.constraint(
                equalToConstant: iconSize
            ),
            heartIconImageView.heightAnchor.constraint(
                equalToConstant: iconSize
            )
        ])
    }
}

// MARK: - Constants
extension FavoriteFoodCell {
    enum Constant {
        enum Layout {
            static let imageSize: CGFloat = 72
            static let cornerRadius: CGFloat = 10
            static let padding: CGFloat = 12
            static let stackSpacing: CGFloat = 4
            static let nameFontSize: CGFloat = 16
            static let priceFontSize: CGFloat = 14
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
            static let heartFill = "heart.fill"
        }

        enum Text {
            static let currencySymbol = "₺"
        }
    }
}
