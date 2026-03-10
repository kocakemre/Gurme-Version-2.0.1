//
//  WelcomeViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 28.09.2022.
//

import UIKit
import Lottie

final class WelcomeViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.titleText
        label.font = UIFont(name: Constants.Font.americanTypewriterBold, size: 40)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.shadowColor = .darkGray
        label.shadowOffset = CGSize(width: 0, height: -1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var welcomeAnimationView: AnimationView = {
        let animationView = AnimationView()
        animationView.animation = Animation.named(Constants.Text.animationName)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = .systemBackground
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    private lazy var welcomeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: Constants.Color.mainOrangeColor)
        view.layer.cornerRadius = Constants.Layout.containerCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.greetingText
        label.font = UIFont(name: Constants.Font.arialBold, size: 30)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.descriptionText
        label.font = UIFont(name: Constants.Font.arialRegular, size: 18)
        label.textColor = .white
        label.numberOfLines = 3
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Text.loginButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.Font.arialBold, size: 20)
        button.backgroundColor = UIColor(named: Constants.Color.mainRedColor)
        button.tintColor = .white // XML'de tintColor kullanılmış
        button.layer.cornerRadius = Constants.Layout.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Text.createAccountButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.Font.arialBold, size: 20)
        button.backgroundColor = UIColor(named: Constants.Color.mainPurpleColor)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.Layout.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        return button
    }()

    // Axis kuralına uygun isimlendirilmiş StackView
    private lazy var actionsVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, createAccountButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Layout.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Properties
    var onLoginTapped: (() -> Void)?
    var onCreateAccountTapped: (() -> Void)?

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        playWelcomeAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playWelcomeAnimation()
    }

    // MARK: - Methods
    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(welcomeAnimationView)
        view.addSubview(welcomeContainerView)

        welcomeContainerView.addSubview(greetingLabel)
        welcomeContainerView.addSubview(descriptionLabel)
        welcomeContainerView.addSubview(actionsVerticalStackView)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -50),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            welcomeAnimationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            welcomeAnimationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 22),
            welcomeAnimationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            welcomeContainerView.heightAnchor.constraint(equalTo: welcomeAnimationView.heightAnchor, multiplier: 0.8),
            welcomeContainerView.topAnchor.constraint(equalTo: welcomeAnimationView.bottomAnchor, constant: 30),
            welcomeContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            welcomeContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            welcomeContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            greetingLabel.topAnchor.constraint(equalTo: welcomeContainerView.topAnchor, constant: 20),
            greetingLabel.centerXAnchor.constraint(equalTo: welcomeContainerView.centerXAnchor),
            greetingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: welcomeContainerView.leadingAnchor, constant: 26),

            descriptionLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: welcomeContainerView.leadingAnchor, constant: 26),
            descriptionLabel.trailingAnchor.constraint(equalTo: welcomeContainerView.trailingAnchor, constant: -26),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 79),

            actionsVerticalStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            actionsVerticalStackView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            actionsVerticalStackView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            actionsVerticalStackView.bottomAnchor.constraint(equalTo: welcomeContainerView.bottomAnchor, constant: -20),

            loginButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func playWelcomeAnimation() {
        if !welcomeAnimationView.isAnimationPlaying {
            welcomeAnimationView.play()
        }
    }

    // MARK: - Action Methods
    @objc private func loginButtonTapped() {
        onLoginTapped?()
    }

    @objc private func createAccountButtonTapped() {
        onCreateAccountTapped?()
    }
}

// MARK: - Constants
private extension WelcomeViewController {
    enum Constants {
        enum Layout {
            static let containerCornerRadius: CGFloat = 50
            static let buttonCornerRadius: CGFloat = 15
            static let stackViewSpacing: CGFloat = 5
        }

        enum Text {
            static let animationName = "hii"
            static let titleText = "Gurme"
            static let greetingText = "Hoşgeldin!"
            static let descriptionText = "Hesabınız var mı? Hemen giriş yapın veya hemen hesap oluşturun Gurme lezzetleri kaçırmayın.."
            static let loginButtonTitle = "Giriş Yap"
            static let createAccountButtonTitle = "Hesap Oluştur"
        }

        enum Color {
            static let mainOrangeColor = "MainOrangeColor"
            static let mainPurpleColor = "MainPurpleColor"
            static let mainRedColor = "MainRedColor"
        }

        enum Font {
            static let americanTypewriterBold = "AmericanTypewriter-Bold"
            static let arialBold = "Arial-BoldMT"
            static let arialRegular = "ArialMT"
        }
    }
}
