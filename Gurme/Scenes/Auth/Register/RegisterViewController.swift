//
//  RegisterViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class RegisterViewController: UIViewController {
    // MARK: - Properties
    var viewModel: RegisterViewModel!
    weak var coordinator: AuthCoordinator?

    // MARK: - UI Properties
    private lazy var registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.title
        label.font = .boldSystemFont(
            ofSize: Constant.Layout.titleFontSize
        )
        label.textAlignment = .center
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = Constant.Text.namePlaceholder
        field.borderStyle = .roundedRect
        field.font = .systemFont(
            ofSize: Constant.Layout.fieldFontSize
        )
        return field
    }()

    private lazy var surnameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = Constant.Text.surnamePlaceholder
        field.borderStyle = .roundedRect
        field.font = .systemFont(
            ofSize: Constant.Layout.fieldFontSize
        )
        return field
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

    private lazy var confirmPasswordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = Constant.Text.confirmPasswordPlaceholder
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.font = .systemFont(
            ofSize: Constant.Layout.fieldFontSize
        )
        return field
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            Constant.Text.registerButtonTitle,
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

    private lazy var verticalFormStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            registerTitleLabel,
            nameTextField,
            surnameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            registerButton
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
private extension RegisterViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constant.Text.navigationTitle
        view.addSubview(verticalFormStackView)

        let fieldViews = [
            nameTextField,
            surnameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField
        ]
        var fieldConstraints: [NSLayoutConstraint] = []
        for field in fieldViews {
            fieldConstraints.append(
                field.heightAnchor.constraint(
                    equalToConstant: Constant.Layout.fieldHeight
                )
            )
        }

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
            registerButton.heightAnchor.constraint(
                equalToConstant: Constant.Layout.buttonHeight
            )
        ] + fieldConstraints)
    }

    func setupActions() {
        registerButton.addTarget(
            self,
            action: #selector(registerButtonTapped),
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
private extension RegisterViewController {
    @objc func registerButtonTapped() {
        viewModel.register(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? "",
            confirmPassword: confirmPasswordTextField.text ?? "",
            name: nameTextField.text ?? "",
            surname: surnameTextField.text ?? ""
        )
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - RegisterViewModelDelegate
extension RegisterViewController: RegisterViewModelDelegate {
    func didRegisterSuccessfully() {
        let alert = UIAlertController(
            title: Constant.Text.successTitle,
            message: Constant.Text.accountCreatedMessage,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: Constant.Text.goToLoginAction,
                style: .default
            ) { [weak self] _ in
                self?.navigationController?.popViewController(
                    animated: true
                )
            }
        )
        present(alert, animated: true)
    }

    func didFailRegister(message: String) {
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
extension RegisterViewController {
    enum Constant {
        enum Layout {
            static let fieldHeight: CGFloat = 48
            static let buttonHeight: CGFloat = 50
            static let padding: CGFloat = 24
            static let stackSpacing: CGFloat = 14
            static let cornerRadius: CGFloat = 12
            static let titleFontSize: CGFloat = 28
            static let fieldFontSize: CGFloat = 16
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
        }

        enum Text {
            static let title = "Hesap Oluştur"
            static let navigationTitle = "Kayıt"
            static let namePlaceholder = "Ad"
            static let surnamePlaceholder = "Soyad"
            static let emailPlaceholder = "Email"
            static let passwordPlaceholder = "Şifre"
            static let confirmPasswordPlaceholder = "Şifre Tekrar"
            static let registerButtonTitle = "Kayıt Ol"
            static let successTitle = "Başarılı"
            static let accountCreatedMessage = "Hesabınız oluşturuldu!"
            static let goToLoginAction = "Giriş Yap"
            static let warningTitle = "Uyarı"
            static let okAction = "Tamam"
        }
    }
}
