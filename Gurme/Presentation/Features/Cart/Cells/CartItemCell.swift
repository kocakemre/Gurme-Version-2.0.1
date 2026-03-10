//
//  CartItemCell.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Kingfisher
import UIKit

final class CartItemCell: UICollectionViewCell {
    // MARK: - UI Properties
    private lazy var foodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.Layout.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.textColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var orderCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: Constant.Layout.countFontSize,
            weight: .regular
        )
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var verticalTextStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                foodNameLabel,
                foodPriceLabel,
                orderCountLabel
            ]
        )
        stack.axis = .vertical
        stack.spacing = Constant.Layout.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        orderCountLabel.text = nil
    }

    // MARK: - Configure
    func configure(with cartItem: CartItem) {
        foodNameLabel.text = cartItem.name
        foodPriceLabel.text = "\(cartItem.totalPrice) ₺"
        orderCountLabel.text = "\(Constant.Text.countPrefix)\(cartItem.orderCount)"
        foodImageView.kf.setImage(with: cartItem.imageURL)
    }
}

// MARK: - UI Setup
private extension CartItemCell {
    func setupUI() {
        contentView.addSubview(foodImageView)
        contentView.addSubview(verticalTextStackView)

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
            verticalTextStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            verticalTextStackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            )
        ])
    }
}

// MARK: - Constants
extension CartItemCell {
    enum Constant {
        enum Layout {
            static let imageSize: CGFloat = 72
            static let cornerRadius: CGFloat = 10
            static let padding: CGFloat = 12
            static let stackSpacing: CGFloat = 4
            static let nameFontSize: CGFloat = 16
            static let priceFontSize: CGFloat = 14
            static let countFontSize: CGFloat = 13
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
        }

        enum Text {
            static let countPrefix = "Adet: "
        }
    }
}
