//
//  RegisterViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit
import Lottie

final class RegisterViewController: UIViewController, AlertShowable {

    // MARK: - Properties
    private var loginPlatformType = ""
    var viewModel: RegisterViewModel!
    weak var coordinator: AuthCoordinator?

    // MARK: - UI Elements

    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.radius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.radius15
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.font14)
        textField.placeholder = Constants.Text.namePlaceholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var surnameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.radius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.radius15
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.font14)
        textField.placeholder = Constants.Text.surnamePlaceholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.emailLabel
        label.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.font20)
        label.textColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.radius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.radius15
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.font14)
        textField.placeholder = Constants.Text.emailPlaceholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.passwordLabel
        label.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.font20)
        label.textColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.radius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.radius15
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.font14)
        textField.placeholder = Constants.Text.passwordPlaceholder
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordAgainLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.passwordAgainLabel
        label.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.font20)
        label.textColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordAgainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.layer.cornerRadius = Constants.Layout.radius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var passwordAgainTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.Layout.radius15
        textField.font = UIFont.systemFont(ofSize: Constants.Layout.font14)
        textField.placeholder = Constants.Text.passwordPlaceholder
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var registerButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: Constants.Text.colorMainPurple)
        view.layer.cornerRadius = Constants.Layout.radius18
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = Constants.Layout.border4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitle(Constants.Text.registerButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.Text.fontHelvetica, size: Constants.Layout.font12)
        button.layer.cornerRadius = Constants.Layout.radius15
        button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var orConnectLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.orConnectLabel
        label.font = UIFont.systemFont(ofSize: Constants.Layout.font14)
        label.textColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var leftSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var rightSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var socialButtonsHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.spacing10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray4
        button.tintColor = .white
        button.setImage(UIImage(named: Constants.Image.appleIcon), for: .normal)
        button.layer.cornerRadius = Constants.Layout.radius18
        button.addTarget(self, action: #selector(appleLoginButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var googleButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: Constants.Text.colorAccent)
        view.layer.cornerRadius = Constants.Layout.radius18
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = Constants.Layout.border1
        return view
    }()

    private lazy var googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .black
        button.setImage(UIImage(named: Constants.Image.googleIcon), for: .normal)
        button.layer.cornerRadius = Constants.Layout.radius18
        button.addTarget(self, action: #selector(googleLoginButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var facebookLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(
            red: Constants.Layout.colorFBRed,
            green: Constants.Layout.colorFBGreen,
            blue: Constants.Layout.colorFBBlue,
            alpha: Constants.Layout.colorFBAlpha
        )
        button.tintColor = .white
        button.setImage(
            UIImage(named: Constants.Image.facebookIcon)?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        button.layer.cornerRadius = Constants.Layout.radius18
        button.addTarget(
            self,
            action: #selector(facebookLoginButtonClicked),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var haveAccountHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.spacing0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var haveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.haveAccountLabel
        label.font = UIFont(name: Constants.Text.fontArialMT, size: Constants.Layout.font17)
        label.textColor = .opaqueSeparator
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Text.loginButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(
            name: Constants.Text.fontArialBold,
            size: Constants.Layout.font17
        )
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var lottieAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()

        viewModel.delegate = self
        self.setupCustomNavigationController()
        self.dismissKeyboardActions()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - Setup UI & Layout
private extension RegisterViewController {

    func setupUI() {
        view.backgroundColor = .systemBackground
        self.title = Constants.Text.pageTitle

        view.addSubview(topSeparatorView)

        nameContainerView.addSubview(nameTextField)
        view.addSubview(nameContainerView)

        surnameContainerView.addSubview(surnameTextField)
        view.addSubview(surnameContainerView)

        view.addSubview(emailLabel)
        emailContainerView.addSubview(emailTextField)
        view.addSubview(emailContainerView)

        view.addSubview(passwordLabel)
        passwordContainerView.addSubview(passwordTextField)
        view.addSubview(passwordContainerView)

        view.addSubview(passwordAgainLabel)
        passwordAgainContainerView.addSubview(passwordAgainTextField)
        view.addSubview(passwordAgainContainerView)

        registerButtonContainerView.addSubview(registerButton)
        view.addSubview(registerButtonContainerView)

        view.addSubview(leftSeparatorView)
        view.addSubview(orConnectLabel)
        view.addSubview(rightSeparatorView)

        googleButtonContainerView.addSubview(googleLoginButton)
        socialButtonsHorizontalStackView.addArrangedSubview(appleLoginButton)
        socialButtonsHorizontalStackView.addArrangedSubview(googleButtonContainerView)
        socialButtonsHorizontalStackView.addArrangedSubview(facebookLoginButton)
        view.addSubview(socialButtonsHorizontalStackView)

        haveAccountHorizontalStackView.addArrangedSubview(haveAccountLabel)
        haveAccountHorizontalStackView.addArrangedSubview(loginButton)
        view.addSubview(haveAccountHorizontalStackView)

        view.addSubview(lottieAnimationView)
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topSeparatorView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: -Constants.Layout.margin3
            ),
            topSeparatorView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            topSeparatorView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            topSeparatorView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height1
            ),

            nameContainerView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: Constants.Layout.margin20
            ),
            nameContainerView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            nameContainerView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            nameContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height50
            ),

            nameTextField.topAnchor.constraint(
                equalTo: nameContainerView.topAnchor,
                constant: Constants.Layout.margin1
            ),
            nameTextField.bottomAnchor.constraint(
                equalTo: nameContainerView.bottomAnchor,
                constant: -Constants.Layout.margin1
            ),
            nameTextField.leadingAnchor.constraint(
                equalTo: nameContainerView.leadingAnchor,
                constant: Constants.Layout.margin1
            ),
            nameTextField.trailingAnchor.constraint(
                equalTo: nameContainerView.trailingAnchor,
                constant: -Constants.Layout.margin1
            ),

            surnameContainerView.topAnchor.constraint(
                equalTo: nameContainerView.bottomAnchor,
                constant: Constants.Layout.margin20
            ),
            surnameContainerView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            surnameContainerView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            surnameContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height50
            ),

            surnameTextField.topAnchor.constraint(
                equalTo: surnameContainerView.topAnchor,
                constant: Constants.Layout.margin1
            ),
            surnameTextField.bottomAnchor.constraint(
                equalTo: surnameContainerView.bottomAnchor,
                constant: -Constants.Layout.margin1
            ),
            surnameTextField.leadingAnchor.constraint(
                equalTo: surnameContainerView.leadingAnchor,
                constant: Constants.Layout.margin1
            ),
            surnameTextField.trailingAnchor.constraint(
                equalTo: surnameContainerView.trailingAnchor,
                constant: -Constants.Layout.margin1
            ),

            emailLabel.topAnchor.constraint(
                equalTo: surnameContainerView.bottomAnchor,
                constant: Constants.Layout.margin20
            ),
            emailLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            emailLabel.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),

            emailContainerView.topAnchor.constraint(
                equalTo: emailLabel.bottomAnchor,
                constant: Constants.Layout.margin5
            ),
            emailContainerView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            emailContainerView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            emailContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height50
            ),

            emailTextField.topAnchor.constraint(
                equalTo: emailContainerView.topAnchor,
                constant: Constants.Layout.margin1
            ),
            emailTextField.bottomAnchor.constraint(
                equalTo: emailContainerView.bottomAnchor,
                constant: -Constants.Layout.margin1
            ),
            emailTextField.leadingAnchor.constraint(
                equalTo: emailContainerView.leadingAnchor,
                constant: Constants.Layout.margin1
            ),
            emailTextField.trailingAnchor.constraint(
                equalTo: emailContainerView.trailingAnchor,
                constant: -Constants.Layout.margin1
            ),

            passwordLabel.topAnchor.constraint(
                equalTo: emailContainerView.bottomAnchor,
                constant: Constants.Layout.margin20
            ),
            passwordLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            passwordLabel.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),

            passwordContainerView.topAnchor.constraint(
                equalTo: passwordLabel.bottomAnchor,
                constant: Constants.Layout.margin5
            ),
            passwordContainerView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            passwordContainerView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            passwordContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height50
            ),

            passwordTextField.topAnchor.constraint(
                equalTo: passwordContainerView.topAnchor,
                constant: Constants.Layout.margin1
            ),
            passwordTextField.bottomAnchor.constraint(
                equalTo: passwordContainerView.bottomAnchor,
                constant: -Constants.Layout.margin1
            ),
            passwordTextField.leadingAnchor.constraint(
                equalTo: passwordContainerView.leadingAnchor,
                constant: Constants.Layout.margin1
            ),
            passwordTextField.trailingAnchor.constraint(
                equalTo: passwordContainerView.trailingAnchor,
                constant: -Constants.Layout.margin1
            ),

            passwordAgainLabel.topAnchor.constraint(
                equalTo: passwordContainerView.bottomAnchor,
                constant: Constants.Layout.margin20
            ),
            passwordAgainLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            passwordAgainLabel.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),

            passwordAgainContainerView.topAnchor.constraint(
                equalTo: passwordAgainLabel.bottomAnchor,
                constant: Constants.Layout.margin5
            ),
            passwordAgainContainerView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            passwordAgainContainerView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            passwordAgainContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height50
            ),

            passwordAgainTextField.topAnchor.constraint(
                equalTo: passwordAgainContainerView.topAnchor,
                constant: Constants.Layout.margin1
            ),
            passwordAgainTextField.bottomAnchor.constraint(
                equalTo: passwordAgainContainerView.bottomAnchor,
                constant: -Constants.Layout.margin1
            ),
            passwordAgainTextField.leadingAnchor.constraint(
                equalTo: passwordAgainContainerView.leadingAnchor,
                constant: Constants.Layout.margin1
            ),
            passwordAgainTextField.trailingAnchor.constraint(
                equalTo: passwordAgainContainerView.trailingAnchor,
                constant: -Constants.Layout.margin1
            ),

            registerButtonContainerView.topAnchor.constraint(
                equalTo: passwordAgainContainerView.bottomAnchor,
                constant: Constants.Layout.margin20
            ),
            registerButtonContainerView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            registerButtonContainerView.widthAnchor.constraint(
                equalTo: passwordAgainContainerView.widthAnchor,
                multiplier: Constants.Layout.multiplierHalf
            ),
            registerButtonContainerView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height40
            ),

            registerButton.topAnchor.constraint(
                equalTo: registerButtonContainerView.topAnchor,
                constant: Constants.Layout.margin4
            ),
            registerButton.bottomAnchor.constraint(
                equalTo: registerButtonContainerView.bottomAnchor,
                constant: -Constants.Layout.margin4
            ),
            registerButton.leadingAnchor.constraint(
                equalTo: registerButtonContainerView.leadingAnchor,
                constant: Constants.Layout.margin4
            ),
            registerButton.trailingAnchor.constraint(
                equalTo: registerButtonContainerView.trailingAnchor,
                constant: -Constants.Layout.margin4
            ),

            orConnectLabel.topAnchor.constraint(
                equalTo: registerButtonContainerView.bottomAnchor,
                constant: Constants.Layout.margin30
            ),
            orConnectLabel.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),

            leftSeparatorView.centerYAnchor.constraint(
                equalTo: orConnectLabel.centerYAnchor
            ),
            leftSeparatorView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            leftSeparatorView.trailingAnchor.constraint(
                equalTo: orConnectLabel.leadingAnchor,
                constant: -Constants.Layout.margin17
            ),
            leftSeparatorView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height1
            ),

            rightSeparatorView.centerYAnchor.constraint(
                equalTo: orConnectLabel.centerYAnchor
            ),
            rightSeparatorView.leadingAnchor.constraint(
                equalTo: orConnectLabel.trailingAnchor,
                constant: Constants.Layout.margin17
            ),
            rightSeparatorView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            rightSeparatorView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.height1
            ),

            socialButtonsHorizontalStackView.topAnchor.constraint(
                equalTo: orConnectLabel.bottomAnchor,
                constant: Constants.Layout.margin15
            ),
            socialButtonsHorizontalStackView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin20
            ),
            socialButtonsHorizontalStackView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin20
            ),
            socialButtonsHorizontalStackView.heightAnchor.constraint(equalToConstant: Constants.Layout.height57),

            googleLoginButton.topAnchor.constraint(
                equalTo: googleButtonContainerView.topAnchor,
                constant: Constants.Layout.margin1
            ),
            googleLoginButton.bottomAnchor.constraint(
                equalTo: googleButtonContainerView.bottomAnchor,
                constant: -Constants.Layout.margin1
            ),
            googleLoginButton.leadingAnchor.constraint(
                equalTo: googleButtonContainerView.leadingAnchor,
                constant: Constants.Layout.margin1
            ),
            googleLoginButton.trailingAnchor.constraint(
                equalTo: googleButtonContainerView.trailingAnchor,
                constant: -Constants.Layout.margin1
            ),

            haveAccountHorizontalStackView.topAnchor.constraint(
                equalTo: socialButtonsHorizontalStackView.bottomAnchor,
                constant: Constants.Layout.margin35
            ),
            haveAccountHorizontalStackView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            haveAccountHorizontalStackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -Constants.Layout.margin50
            ),

            lottieAnimationView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: Constants.Layout.margin78
            ),
            lottieAnimationView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constants.Layout.margin11
            ),
            lottieAnimationView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constants.Layout.margin11
            ),
            lottieAnimationView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -Constants.Layout.margin228
            )]
        )
    }
}

// MARK: - Private Methods
private extension RegisterViewController {

    func dismissKeyboardActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func playRegisterAnimation() {
        let animation = Animation.named(Constants.Image.partyAnimation)
        lottieAnimationView.animation = animation
        lottieAnimationView.loopMode = .playOnce
        lottieAnimationView.animationSpeed = Constants.Layout.animSpeedHalf

        if !lottieAnimationView.isAnimationPlaying {
            lottieAnimationView.play()
        }
    }

    func showLoginAlert() {
        let title = Constants.Text.alertWarningTitle
        var message = ""

        switch loginPlatformType {
            case Constants.Text.platformApple:
                message = Constants.Text.appleErrorMsg
            case Constants.Text.platformGoogle:
                message = Constants.Text.googleErrorMsg
            default:
                message = Constants.Text.facebookErrorMsg
        }

        showAlert(arguments: AlertArguments(
            title: title,
            message: message,
            buttonTitle: Constants.Text.alertOkButton
        ))
    }

}

// MARK: - Action Methods
private extension RegisterViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupCustomNavigationController() {
        let backButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: Constants.Image.backIcon)
        self.navigationController?.navigationBar.barStyle = .black
    }

    @objc func backButtonTapped() {
        _ = navigationController?.popToRootViewController(animated: true)
    }

    @objc func loginButtonClicked() {
        coordinator?.showLoginPage()
    }

    @objc func registerButtonClicked() {

        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordAgain = passwordAgainTextField.text, !passwordAgain.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let surname = surnameTextField.text, !surname.isEmpty else {
            showAlert(arguments: AlertArguments(
                title: Constants.Text.alertWarningTitle,
                message: Constants.Text.emptyFieldsWarning,
                buttonTitle: Constants.Text.alertOkButton
            ))
            return
        }

        viewModel.register(
            email: email,
            password: password,
            confirmPassword: passwordAgain,
            name: name,
            surname: surname
        )
    }

    @objc func appleLoginButtonClicked() {
        loginPlatformType = Constants.Text.platformApple
        self.showLoginAlert()
    }

    @objc func googleLoginButtonClicked() {
        loginPlatformType = Constants.Text.platformGoogle
        self.showLoginAlert()
    }

    @objc func facebookLoginButtonClicked() {
        loginPlatformType = Constants.Text.platformFacebook
        self.showLoginAlert()
    }
}

// MARK: - RegisterViewModelDelegate
extension RegisterViewController: RegisterViewModelDelegate {

    func didRegisterSuccessfully() {
        self.lottieAnimationView.isHidden = false
        self.playRegisterAnimation()

        showAlert(arguments: AlertArguments(
            title: Constants.Text.alertSuccessTitle,
            message: Constants.Text.registerSuccessMsg,
            buttonTitle: Constants.Text.alertOkButton
        ))
    }

    func didFailRegister(message: String) {
        showAlert(arguments: AlertArguments(
            title: Constants.Text.alertWarningTitle,
            message: message,
            buttonTitle: Constants.Text.alertOkButton
        ))
    }
}

// MARK: - Constants
private extension RegisterViewController {

    enum Constants {

        enum Layout {
            // Colors & Alpha
            static let colorFBRed: CGFloat = 0.28
            static let colorFBGreen: CGFloat = 0.58
            static let colorFBBlue: CGFloat = 0.90
            static let colorFBAlpha: CGFloat = 1.0

            // Radiuses & Borders
            static let radius15: CGFloat = 15
            static let radius18: CGFloat = 18
            static let border1: CGFloat = 1
            static let border4: CGFloat = 4

            // Fonts
            static let font12: CGFloat = 12
            static let font14: CGFloat = 14
            static let font17: CGFloat = 17
            static let font20: CGFloat = 20

            // Heights & Multipliers
            static let height1: CGFloat = 1
            static let height40: CGFloat = 40
            static let height50: CGFloat = 50
            static let height57: CGFloat = 57
            static let multiplierHalf: CGFloat = 0.5

            // Spacing & Margins
            static let spacing0: CGFloat = 0
            static let spacing10: CGFloat = 10
            static let margin1: CGFloat = 1
            static let margin3: CGFloat = 3
            static let margin4: CGFloat = 4
            static let margin5: CGFloat = 5
            static let margin11: CGFloat = 11
            static let margin15: CGFloat = 15
            static let margin17: CGFloat = 17
            static let margin20: CGFloat = 20
            static let margin30: CGFloat = 30
            static let margin35: CGFloat = 35
            static let margin50: CGFloat = 50
            static let margin78: CGFloat = 78
            static let margin228: CGFloat = 228

            // Anim Speed
            static let animSpeedHalf: CGFloat = 0.5
        }

        enum Text {
            // Titles & Placeholders
            static let pageTitle = "Üyelik"
            static let namePlaceholder = " Adınız"
            static let surnamePlaceholder = " Soyadınız"
            static let emailLabel = "E-mail"
            static let emailPlaceholder = " Email giriş yapmak ve şifre hatırlatmak için kullanılır."
            static let passwordLabel = "Şifre"
            static let passwordPlaceholder = " 6 karakterden oluşmalıdır."
            static let passwordAgainLabel = "Şifreyi Tekrarla"
            static let registerButtonTitle = "Üye Ol"
            static let orConnectLabel = "veya hesabınızla bağlanın"
            static let haveAccountLabel = "Hesabınız var mı? "
            static let loginButtonTitle = "Giriş Yap"

            // Alerts & Messages
            static let alertWarningTitle = "Uyarı"
            static let alertSuccessTitle = "Başarılı"
            static let alertOkButton = "Tamam"
            static let emptyFieldsWarning = "Lütfen boş alanları doldurunuz!"
            static let registerSuccessMsg = "Kullanıcı başarıyla oluşturuldu."
            static let appleErrorMsg = "Apple'a bağlanırken bir sorun oluştu😔 Daha sonra tekrar deneyiniz."
            static let googleErrorMsg = "Google'a bağlanırken bir sorun oluştu😔 Daha sonra tekrar deneyiniz."
            static let facebookErrorMsg = "Facebook'a bağlanırken bir sorun oluştu😔 Daha sonra tekrar deneyiniz."

            // Platform
            static let platformApple = "Apple"
            static let platformGoogle = "Google"
            static let platformFacebook = "Facebook"

            // Fonts & Colors (String Names)
            static let fontArialMT = "ArialMT"
            static let fontArialBold = "Arial-BoldMT"
            static let fontHelvetica = "Helvetica"
            static let colorMainPurple = "MainPurpleColor"
            static let colorAccent = "AccentColor"
        }

        enum Image {
            // Assets
            static let appleIcon = "appleIcon"
            static let googleIcon = "googleIcon"
            static let facebookIcon = "facebookIcon"
            static let backIcon = "back"

            // Animations
            static let partyAnimation = "party"
        }
    }
}
