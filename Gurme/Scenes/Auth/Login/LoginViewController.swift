//
//  LoginViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit
import Lottie

final class LoginViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var accountAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .systemBackground
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var partyAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .systemBackground
        view.contentMode = .scaleAspectFill
        view.isHidden = true
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
        button.titleLabel?.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.subButtonFontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = Constants.Text.loginButtonTitle

        let button = UIButton(configuration: configuration)
        button.backgroundColor = UIColor(named: Constants.Text.colorMainRed)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: Constants.Text.fontArialBoldMT, size: Constants.Layout.mainButtonFontSize)
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
        button.titleLabel?.font = UIFont(name: Constants.Text.fontArialBoldMT, size: Constants.Layout.mainButtonFontSize)
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - StackViews

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

    // MARK: - Properties

    var viewModel: LoginViewModel!
    weak var coordinator: AuthCoordinator?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        configureUI()
        dismissKeyboardActions()
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
}

// MARK: - UI Setup Methods
private extension LoginViewController {

    func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(topSeparatorView)
        view.addSubview(accountAnimationView)
        view.addSubview(partyAnimationView)

        emailContainerView.addSubview(emailTextField)
        passwordContainerView.addSubview(passwordTextField)

        view.addSubview(formVerticalStackView)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // Top Separator
            topSeparatorView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.Layout.topSeparatorTop),
            topSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            topSeparatorView.heightAnchor.constraint(equalToConstant: Constants.Layout.topSeparatorHeight),

            // Account Animation
            accountAnimationView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: Constants.Layout.accountAnimTop),
            accountAnimationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.Layout.accountAnimLeading),
            accountAnimationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: Constants.Layout.accountAnimTrailing),
            accountAnimationView.heightAnchor.constraint(equalToConstant: Constants.Layout.accountAnimHeight),

            // TextFields inside Containers (1px border effect)
            emailTextField.topAnchor.constraint(equalTo: emailContainerView.topAnchor, constant: Constants.Layout.textFieldInset),
            emailTextField.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: -Constants.Layout.textFieldInset),
            emailTextField.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: Constants.Layout.textFieldInset),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -Constants.Layout.textFieldInset),
            emailContainerView.heightAnchor.constraint(equalToConstant: Constants.Layout.textFieldContainerHeight),

            passwordTextField.topAnchor.constraint(equalTo: passwordContainerView.topAnchor, constant: Constants.Layout.textFieldInset),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: -Constants.Layout.textFieldInset),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: Constants.Layout.textFieldInset),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -Constants.Layout.textFieldInset),
            passwordContainerView.heightAnchor.constraint(equalToConstant: Constants.Layout.textFieldContainerHeight),

            // Form StackView
            formVerticalStackView.topAnchor.constraint(equalTo: accountAnimationView.bottomAnchor, constant: Constants.Layout.formStackTop),
            formVerticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.Layout.formStackHorizontal),
            formVerticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.Layout.formStackHorizontal),

            // Forgot Password Button
            forgotPasswordButton.topAnchor.constraint(equalTo: formVerticalStackView.bottomAnchor, constant: Constants.Layout.forgotPasswordTop),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: formVerticalStackView.trailingAnchor),

            // Login Button
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: Constants.Layout.loginButtonTop),
            loginButton.leadingAnchor.constraint(equalTo: formVerticalStackView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: formVerticalStackView.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),

            // Create Account Button
            createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.Layout.createAccountButtonTop),
            createAccountButton.leadingAnchor.constraint(equalTo: formVerticalStackView.leadingAnchor),
            createAccountButton.trailingAnchor.constraint(equalTo: formVerticalStackView.trailingAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),

            // Party Animation View
            partyAnimationView.topAnchor.constraint(equalTo: accountAnimationView.bottomAnchor, constant: Constants.Layout.partyAnimTop),
            partyAnimationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.Layout.partyAnimLeading),
            partyAnimationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: Constants.Layout.partyAnimTrailing),
            partyAnimationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: Constants.Layout.partyAnimBottom)
        ])
    }

    func configureUI() {
        title = Constants.Text.pageTitle
        navigationControllerCustom()
        loginAnimation()
    }
}

// MARK: - Action Methods
extension LoginViewController {

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func loginButtonTapped() {
        partyAnimationView.isHidden = false
        btnLoginClickedAnimation()
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    @objc private func createAccountButtonTapped() {
        coordinator?.showRegister()
    }

    @objc private func back(sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Private Helper Methods
private extension LoginViewController {

    func dismissKeyboardActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func navigationControllerCustom() {
        let backButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(back(sender:))
        )
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.image = UIImage(named: Constants.Image.backIcon)
        navigationController?.navigationBar.barStyle = .black
    }

    func loginAnimation() {
        let animation = Animation.named(Constants.Text.accountAnimationName)
        accountAnimationView.animation = animation
        accountAnimationView.loopMode = .loop
        accountAnimationView.animationSpeed = Constants.Layout.animationSpeed

        if !accountAnimationView.isAnimationPlaying {
            accountAnimationView.play()
        }
    }

    func btnLoginClickedAnimation() {
        let animation = Animation.named(Constants.Text.partyAnimationName)
        partyAnimationView.animation = animation
        partyAnimationView.loopMode = .playOnce
        partyAnimationView.animationSpeed = Constants.Layout.animationSpeed

        if !partyAnimationView.isAnimationPlaying {
            partyAnimationView.play()
        }
    }

    func standartAlert(
        _ title: String?,
        _ message: String?,
        _ preferredStyle: UIAlertController.Style,
        _ buttonTitle: String?,
        _ buttonStyle: UIAlertAction.Style
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle))
        present(alert, animated: true)
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {

    func didLoginSuccessfully() {
        coordinator?.didFinishAuth()
    }

    func didFailLogin(message: String) {
        standartAlert(Constants.Text.alertTitle, message, .alert, Constants.Text.alertOkButton, .default)
    }
}

// MARK: - Constants
private extension LoginViewController {

    enum Constants {
        enum Layout {
            // General
            static let cornerRadius: CGFloat = 15
            static let smallSpacing: CGFloat = 5
            static let mediumSpacing: CGFloat = 10
            static let animationSpeed: Double = 0.5

            // Fonts
            static let titleFontSize: CGFloat = 20
            static let detailFontSize: CGFloat = 12
            static let passwordFontSize: CGFloat = 14
            static let subButtonFontSize: CGFloat = 14
            static let mainButtonFontSize: CGFloat = 20

            // UI Constraints
            static let topSeparatorTop: CGFloat = 3
            static let topSeparatorHeight: CGFloat = 1

            static let accountAnimTop: CGFloat = 12
            static let accountAnimLeading: CGFloat = 18
            static let accountAnimTrailing: CGFloat = -4
            static let accountAnimHeight: CGFloat = 321

            static let textFieldInset: CGFloat = 1
            static let textFieldContainerHeight: CGFloat = 50

            static let formStackTop: CGFloat = 10
            static let formStackHorizontal: CGFloat = 20

            static let forgotPasswordTop: CGFloat = 8

            static let loginButtonTop: CGFloat = 20
            static let createAccountButtonTop: CGFloat = 10
            static let buttonHeight: CGFloat = 46

            static let partyAnimTop: CGFloat = -3
            static let partyAnimLeading: CGFloat = 10
            static let partyAnimTrailing: CGFloat = -12
            static let partyAnimBottom: CGFloat = -124
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
