//
//  SliderCell.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class SliderCell: UICollectionViewCell {
    // MARK: - UI Properties
    private lazy var sliderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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

    // MARK: - Configure
    func configure(with item: SliderItem) {
        sliderImageView.image = UIImage(named: item.imageName)
    }
}

// MARK: - UI Setup
private extension SliderCell {
    func setupUI() {
        contentView.layer.cornerRadius = Constant.Layout.cornerRadius
        contentView.clipsToBounds = true
        contentView.addSubview(sliderImageView)
        NSLayoutConstraint.activate([
            sliderImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            sliderImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            sliderImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            sliderImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }
}

// MARK: - Constants
extension SliderCell {
    enum Constant {
        enum Layout {
            static let cornerRadius: CGFloat = 16
        }
    }
}
