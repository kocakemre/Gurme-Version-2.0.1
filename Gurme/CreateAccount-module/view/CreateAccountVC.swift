//
//  CreateAccountVC.swift
//  Gurme
//
//  Created by Emre Kocak on 28.09.2022.
//

import UIKit
import Lottie

final class CreateAccountVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet private weak var lottieView: AnimationView!
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPassword: UITextField!
    @IBOutlet private weak var textFieldAgainPassword: UITextField!
    @IBOutlet private weak var textFieldName: UITextField!
    @IBOutlet private weak var textFieldSurname: UITextField!
    
    private var logo = ""
    weak var createAccountPresenterObject: ViewToPresenterCreateAccountProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CreateAccountRouter.createModule(ref: self)
        self.navigationControllerCustom()
        
        
        self.dismissKeyboardActions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - Private Methods
private
extension CreateAccountVC {
    
    func dismissKeyboardActions() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    func btnCreateAccountClickedAnimation() {
        
        let animation = Animation.named("party")
        lottieView.animation = animation
        lottieView.loopMode = .playOnce
        lottieView.animationSpeed = 0.5
        
        if (!lottieView.isAnimationPlaying){
            lottieView.play()
        }
    }
    
    func alertLogin() {
        
        var alertController = UIAlertController()
        
        if logo == "Apple" {
            alertController = UIAlertController(
                title: "Uyarı",
                message: "Apple'a bağlanırken bir sorun oluştu😔 Daha sonra tekrar deneyiniz.",
                preferredStyle: .alert
            )
            
        } else if logo == "Google" {
            alertController = UIAlertController(
                title: "Uyarı",
                message: "Google'a bağlanırken bir sorun oluştu😔 Daha sonra tekrar deneyiniz.",
                preferredStyle: .alert
            )
            
        } else {
            alertController = UIAlertController(
                title: "Uyarı",
                message: "Facebook'a bağlanırken bir sorun oluştu😔 Daha sonra tekrar deneyiniz.",
                preferredStyle: .alert
            )
            
        }
        
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func standartAlert(
        _ title: String?,
        _ messsage: String?,
        _ preferredStyle: UIAlertController.Style,
        _ buttonTitle: String?,
        _ buttonStyle: UIAlertAction.Style
    ) {
        let alert = UIAlertController(
            title: title,
            message: messsage,
            preferredStyle: preferredStyle
        )
        alert.addAction(
            UIAlertAction(
                title: buttonTitle,
                style: buttonStyle
            )
        )
        self.present(
            alert,
            animated: true
        )
    }
}

// MARK: - Action Methods
private
extension CreateAccountVC {
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func navigationControllerCustom() {
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(CreateAccountVC.back(sender:))
        )
        //self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnLoginClicked_TUI(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func btnRegisterClicked_TUI(_ sender: Any) {
        
        if textFieldEmail.text != "" &&
            textFieldPassword.text != "" &&
            textFieldAgainPassword.text != "" &&
            textFieldName.text != "" &&
            textFieldSurname.text != "" {
            
            if textFieldPassword.text == textFieldAgainPassword.text {
                
                createAccountPresenterObject?.register(
                    email: textFieldEmail.text!,
                    password: textFieldPassword.text!
                )
            } else {
                standartAlert(
                    "Uyarı",
                    "Parolalar uyuşmamaktadır. İki parolada aynı olmalıdır.",
                    .alert,
                    "Tamam",
                    .default
                )
            }
            
        } else {
            standartAlert(
                "Uyarı",
                "Lütfen boş alanları doldurunuz!",
                .alert,
                "Tamam",
                .default
            )
        }
        
    }
    
    @IBAction func btnAppleLoginClicked_TUI(_ sender: Any) {
        logo = "Apple"
        self.alertLogin()
    }
    
    @IBAction func btnGoogleLoginClicked_TUI(_ sender: Any) {
        logo = "Google"
        self.alertLogin()
    }
    @IBAction func btnFacebookLoginClicked_TUI(_ sender: Any) {
        logo = "Facebook"
        self.alertLogin()
    }
}

// MARK: - PresenterToViewCreateAccountProtocol
extension CreateAccountVC: PresenterToViewCreateAccountProtocol {
    
    func dataTransferToView(error: Bool) {
        if error {
            standartAlert(
                "Uyarı",
                createAccountPresenterObject?.createAccountInteractor?.createAccountError,
                .alert,
                "Tamam",
                .default
            )
        } else {
            self.lottieView.isHidden = false
            self.btnCreateAccountClickedAnimation()
            let alert = UIAlertController(
                title: "Başarılı",
                message: "Kullanıcı başarıyla oluşturuldu.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            }))
            present(alert, animated: true)
        }
    }
    
}
