//
//  LoginViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    var viewModel: LoginViewModel!
    weak var coordinator: AuthCoordinator?

    // MARK: - UI Properties
    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.title
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.titleFontSize
        )
        label.textAlignment = .center
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = Constant.Text.emailPlaceholder
        field.borderStyle = .roundedRect
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = .systemFont(
            ofSize: Constant.Layout.fieldFontSize
        )
        return field
    }()

    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = Constant.Text.passwordPlaceholder
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.font = .systemFont(
            ofSize: Constant.Layout.fieldFontSize
        )
        return field
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            Constant.Text.loginButtonTitle,
            for: .normal
        )
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(
            ofSize: Constant.Layout.fieldFontSize
        )
        button.backgroundColor = UIColor(
            named: Constant.Image.mainOrangeColor
        )
        button.layer.cornerRadius = Constant.Layout.cornerRadius
        return button
    }()

    private lazy var navigateToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            Constant.Text.createAccountTitle,
            for: .normal
        )
        button.setTitleColor(
            UIColor(named: Constant.Image.mainOrangeColor),
            for: .normal
        )
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            Constant.Text.skipButtonTitle,
            for: .normal
        )
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()

    private lazy var verticalFormStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            loginTitleLabel,
            emailTextField,
            passwordTextField,
            loginButton,
            navigateToRegisterButton,
            skipButton
        ])
        stack.axis = .vertical
        stack.spacing = Constant.Layout.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDismissKeyboard()
    }
}

// MARK: - UI Setup
private extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(verticalFormStackView)

        NSLayoutConstraint.activate([
            verticalFormStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            verticalFormStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constant.Layout.padding
            ),
            verticalFormStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constant.Layout.padding
            ),
            emailTextField.heightAnchor.constraint(
                equalToConstant: Constant.Layout.fieldHeight
            ),
            passwordTextField.heightAnchor.constraint(
                equalToConstant: Constant.Layout.fieldHeight
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.buttonHeight
            )
        ])
    }

    func setupActions() {
        loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
        navigateToRegisterButton.addTarget(
            self,
            action: #selector(navigateToRegisterButtonTapped),
            for: .touchUpInside
        )
        skipButton.addTarget(
            self,
            action: #selector(skipButtonTapped),
            for: .touchUpInside
        )
    }

    func setupDismissKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Action Methods
private extension LoginViewController {
    @objc func loginButtonTapped() {
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    @objc func navigateToRegisterButtonTapped() {
        coordinator?.showRegister()
    }

    @objc func skipButtonTapped() {
        viewModel.skipLogin()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func didLoginSuccessfully() {
        coordinator?.didFinishAuth()
    }

    func didFailLogin(message: String) {
        let alert = UIAlertController(
            title: Constant.Text.warningTitle,
            message: message,
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
extension LoginViewController {
    enum Constant {
        enum Layout {
            static let fieldHeight: CGFloat = 48
            static let buttonHeight: CGFloat = 50
            static let padding: CGFloat = 24
            static let stackSpacing: CGFloat = 16
            static let cornerRadius: CGFloat = 12
            static let titleFontSize: CGFloat = 28
            static let fieldFontSize: CGFloat = 16
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
        }

        enum Text {
            static let title = "Giriş Yap"
            static let emailPlaceholder = "Email"
            static let passwordPlaceholder = "Şifre"
            static let loginButtonTitle = "Giriş"
            static let createAccountTitle = "Hesap Oluştur"
            static let skipButtonTitle = "Atla"
            static let warningTitle = "Uyarı"
            static let okAction = "Tamam"
        }
    }
}
