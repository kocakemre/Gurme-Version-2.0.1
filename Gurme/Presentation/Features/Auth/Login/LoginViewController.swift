//
//  LoginViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit
import Lottie

final class LoginViewController: UIViewController, AlertShowable {
    // MARK: - UI Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var accountAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .systemBackground
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var partyAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .systemBackground
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.emailTitle
        label.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.titleFontSize)
        label.textColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.Text.emailPlaceholder
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.detailFontSize)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.cornerRadius
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var emailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.passwordTitle
        label.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.titleFontSize)
        label.textColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.Text.passwordPlaceholder
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.passwordFontSize)
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.cornerRadius
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var forgotPasswordButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = Constants.Text.forgotPasswordTitle
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont(
            name: Constants.Text.fontArialMT,
            size: Constants.Layout.subButtonFontSize
        )
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = Constants.Text.loginButtonTitle
        let button = UIButton(configuration: configuration)
        button.backgroundColor = UIColor(named: Constants.Text.colorMainRed)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(
            name: Constants.Text.fontArialBoldMT,
            size: Constants.Layout.mainButtonFontSize
        )
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var createAccountButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = Constants.Text.createAccountButtonTitle
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .systemGroupedBackground
        button.tintColor = UIColor(named: Constants.Text.colorMainPurple)
        button.titleLabel?.font = UIFont(
            name: Constants.Text.fontArialBoldMT,
            size: Constants.Layout.mainButtonFontSize
        )
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Stack Views

    private lazy var emailVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTitleLabel, emailContainerView])
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.smallSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var passwordVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTitleLabel, passwordContainerView])
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.smallSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var formVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailVerticalStackView, passwordVerticalStackView])
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.mediumSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var buttonGroupStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, createAccountButton])
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.buttonGroupSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            formVerticalStackView,
            forgotPasswordButton,
            buttonGroupStackView
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Properties

    var viewModel: LoginViewModel!
    weak var coordinator: AuthCoordinator?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        configureUI()
        setupDismissKeyboardGesture()
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
}

// MARK: - Setup Hierarchy
private extension LoginViewController {

    func setupHierarchy() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(topSeparatorView)
        contentView.addSubview(accountAnimationView)
        contentView.addSubview(mainStackView)

        emailContainerView.addSubview(emailTextField)
        passwordContainerView.addSubview(passwordTextField)

        // Party animation is a full-screen overlay above all content
        view.addSubview(partyAnimationView)
    }
}

// MARK: - Setup Constraints
private extension LoginViewController {

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        // Proportional height (35% of screen), hard-capped at 321 pt — adapts to any device
        let proportionalAnimHeight = accountAnimationView.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: Constants.Layout.animationHeightRatio
        )
        proportionalAnimHeight.priority = .defaultHigh

        let maxAnimHeight = accountAnimationView.heightAnchor.constraint(
            lessThanOrEqualToConstant: Constants.Layout.accountAnimMaxHeight
        )

        mainStackView.setCustomSpacing(Constants.Layout.forgotPasswordSpacing, after: formVerticalStackView)
        mainStackView.setCustomSpacing(Constants.Layout.buttonGroupTopSpacing, after: forgotPasswordButton)

        NSLayoutConstraint.activate([
            // Scroll View — pinned to safe area
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            // Content View — width locked to scroll view width; height is intrinsic
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Top Separator
            topSeparatorView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.Layout.topSeparatorTop
            ),
            topSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topSeparatorView.heightAnchor.constraint(equalToConstant: Constants.Layout.topSeparatorHeight),

            // Account Animation — responsive height via multiplier + cap
            accountAnimationView.topAnchor.constraint(
                equalTo: topSeparatorView.bottomAnchor,
                constant: Constants.Layout.accountAnimTop
            ),
            accountAnimationView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.Layout.horizontalPadding
            ),
            accountAnimationView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.Layout.horizontalPadding
            ),
            proportionalAnimHeight,
            maxAnimHeight,

            // TextField Containers (1 pt border effect)
            emailContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.textFieldContainerHeight
            ),
            emailTextField.topAnchor.constraint(
                equalTo: emailContainerView.topAnchor,
                constant: Constants.Layout.textFieldInset
            ),
            emailTextField.bottomAnchor.constraint(
                equalTo: emailContainerView.bottomAnchor,
                constant: -Constants.Layout.textFieldInset
            ),
            emailTextField.leadingAnchor.constraint(
                equalTo: emailContainerView.leadingAnchor,
                constant: Constants.Layout.textFieldInset
            ),
            emailTextField.trailingAnchor.constraint(
                equalTo: emailContainerView.trailingAnchor,
                constant: -Constants.Layout.textFieldInset
            ),

            passwordContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.textFieldContainerHeight
            ),
            passwordTextField.topAnchor.constraint(
                equalTo: passwordContainerView.topAnchor,
                constant: Constants.Layout.textFieldInset
            ),
            passwordTextField.bottomAnchor.constraint(
                equalTo: passwordContainerView.bottomAnchor,
                constant: -Constants.Layout.textFieldInset
            ),
            passwordTextField.leadingAnchor.constraint(
                equalTo: passwordContainerView.leadingAnchor,
                constant: Constants.Layout.textFieldInset
            ),
            passwordTextField.trailingAnchor.constraint(
                equalTo: passwordContainerView.trailingAnchor,
                constant: -Constants.Layout.textFieldInset
            ),

            // Button Heights
            loginButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),

            // Main Stack — anchored below animation, defines scroll content height
            mainStackView.topAnchor.constraint(
                equalTo: accountAnimationView.bottomAnchor,
                constant: Constants.Layout.mainStackTop
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.Layout.horizontalPadding
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.Layout.horizontalPadding
            ),
            mainStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.Layout.bottomPadding
            ),

            // Party Animation — full-screen overlay; covers screen on login attempt
            partyAnimationView.topAnchor.constraint(equalTo: view.topAnchor),
            partyAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            partyAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            partyAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Configure UI
private extension LoginViewController {

    func configureUI() {
        title = Constants.Text.pageTitle
        setupNavigationBar()
        startLoginAnimation()
    }

    func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.image = UIImage(named: Constants.Image.backIcon)
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.barStyle = .black
    }

    func startLoginAnimation() {
        accountAnimationView.animation = Animation.named(Constants.Text.accountAnimationName)
        accountAnimationView.loopMode = .loop
        accountAnimationView.animationSpeed = Constants.Layout.animationSpeed
        if !accountAnimationView.isAnimationPlaying {
            accountAnimationView.play()
        }
    }

    func startPartyAnimation() {
        partyAnimationView.animation = Animation.named(Constants.Text.partyAnimationName)
        partyAnimationView.loopMode = .playOnce
        partyAnimationView.animationSpeed = Constants.Layout.animationSpeed
        if !partyAnimationView.isAnimationPlaying {
            partyAnimationView.play()
        }
    }

    func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }


}

// MARK: - Action Methods
extension LoginViewController {

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func loginButtonTapped() {
        partyAnimationView.isHidden = false
        startPartyAnimation()
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    @objc private func createAccountButtonTapped() {
        coordinator?.showRegister()
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {

    func didLoginSuccessfully() {
        coordinator?.didFinishAuth()
    }

    func didFailLogin(message: String) {
        partyAnimationView.isHidden = true
        showAlert(arguments: AlertArguments(
            title: Constants.Text.alertTitle,
            message: message,
            buttonTitle: Constants.Text.alertOkButton
        ))
    }
}

// MARK: - Constants
private extension LoginViewController {

    enum Constants {
        enum Layout {
            // Visual style
            static let cornerRadius: CGFloat = 15
            static let animationSpeed: Double = 0.5

            // Font sizes
            static let titleFontSize: CGFloat = 20
            static let detailFontSize: CGFloat = 12
            static let passwordFontSize: CGFloat = 14
            static let subButtonFontSize: CGFloat = 14
            static let mainButtonFontSize: CGFloat = 20

            // Spacing
            static let smallSpacing: CGFloat = 5
            static let mediumSpacing: CGFloat = 10
            static let horizontalPadding: CGFloat = 20
            static let bottomPadding: CGFloat = 16
            static let mainStackTop: CGFloat = 10
            static let forgotPasswordSpacing: CGFloat = 8
            static let buttonGroupTopSpacing: CGFloat = 20
            static let buttonGroupSpacing: CGFloat = 10

            // Top separator
            static let topSeparatorTop: CGFloat = 3
            static let topSeparatorHeight: CGFloat = 1

            // Animation
            static let accountAnimTop: CGFloat = 12
            static let animationHeightRatio: CGFloat = 0.35
            static let accountAnimMaxHeight: CGFloat = 321

            // Text fields
            static let textFieldInset: CGFloat = 1
            static let textFieldContainerHeight: CGFloat = 50

            // Buttons
            static let buttonHeight: CGFloat = 46
        }

        enum Text {
            static let pageTitle = "Giriş"
            static let emailTitle = "E-mail"
            static let emailPlaceholder = "  Email giriş yapmak ve şifre hatırlatmak için kullanılır."
            static let passwordTitle = "Şifre"
            static let passwordPlaceholder = "  6 karakterden oluşmalıdır."
            static let forgotPasswordTitle = "Şifrenizi mi unuttunuz?"
            static let loginButtonTitle = "Giriş Yap"
            static let createAccountButtonTitle = "Hesap Oluştur"

            static let fontArialMT = "ArialMT"
            static let fontArialBoldMT = "Arial-BoldMT"

            static let colorMainRed = "MainRedColor"
            static let colorMainPurple = "MainPurpleColor"

            static let accountAnimationName = "account"
            static let partyAnimationName = "party"

            static let alertTitle = "Uyarı"
            static let alertOkButton = "Tamam"
        }

        enum Image {
            static let backIcon = "back"
        }
    }
}
