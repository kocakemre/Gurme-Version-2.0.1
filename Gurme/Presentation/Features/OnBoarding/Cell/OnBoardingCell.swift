//
//  OnBoardingCell.swift
//  Gurme
//
//  Created by Emre Kocak on 25.09.2022.
//

import Lottie
import UIKit

final class OnBoardingCell: UICollectionViewCell {

    // MARK: - UI Properties
    private let lottieView: AnimationView = {
        let view = AnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.animationSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let childLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    static let identifierCell = String(describing: OnBoardingCell.self)
    var btnActionTap: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Methods
    func configureCell(_ slide: OnBoardingSlide) {
        headLabel.text = slide.titleHead
        childLabel.text = slide.titleChild
        actionButton.backgroundColor = slide.btnColor
        actionButton.setTitle(slide.btnTitle, for: .normal)

        lottieView.animation = Animation.named(slide.animationName)
        if !lottieView.isAnimationPlaying {
            lottieView.play()
        }
    }
}

// MARK: - Setup
private extension OnBoardingCell {

    func setupUI() {
        contentView.addSubview(lottieView)
        contentView.addSubview(headLabel)
        contentView.addSubview(childLabel)
        contentView.addSubview(actionButton)

        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            lottieView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            lottieView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lottieView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),

            headLabel.topAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: 16),
            headLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            childLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 12),
            childLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            childLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            actionButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Layout.actionButtonBottomInset
            ),
            actionButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Layout.horizontalInset
            ),
            actionButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Layout.horizontalInset
            ),
            actionButton.heightAnchor.constraint(equalToConstant: Layout.actionButtonHeight)
        ])
    }

    @objc func actionButtonTapped() {
        btnActionTap?()
    }
}

// MARK: - Layout Constants
private extension OnBoardingCell {
    enum Layout {
        static let actionButtonBottomInset: CGFloat = 40
        static let actionButtonHeight: CGFloat = 52
        static let horizontalInset: CGFloat = 32
    }
}
