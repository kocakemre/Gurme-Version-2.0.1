//
//  VC_Login.swift
//  Gurme
//
//  Created by Emre Kocak on 28.09.2022.
//

import UIKit
import Lottie

class VC_Login: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var lottieView2: AnimationView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var loginPresenterObject: ViewToPresenterLoginProtocol?
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Giriş"
        self.loginAnimation()
        self.navigationControllerCustom()
        
        LoginRouter.createRouter(ref: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Giriş"
        self.loginAnimation()
        
    }
    
    // MARK: - Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func dismissKeyboardActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func navigationControllerCustom() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(VC_Login.back(sender:)))
        //self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func loginAnimation() {
       
        let animation = Animation.named("account")
        lottieView.animation = animation
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        
        if (!lottieView.isAnimationPlaying){
            lottieView.play()
        }
    }
    
    func btnLoginClickedAnimation() {
       
        let animation = Animation.named("party")
        lottieView2.animation = animation
        lottieView2.loopMode = .playOnce
        lottieView2.animationSpeed = 0.5
        
        if (!lottieView2.isAnimationPlaying){
            lottieView2.play()
        }
    }
    
    func standartAlert(_ title: String?, _ messsage: String?, _ preferredStyle: UIAlertController.Style, _ buttonTitle: String?, _ buttonStyle: UIAlertAction.Style) {
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle))
        self.present(alert, animated: true)
    }


    // MARK: - UI Elements

    @IBAction func btnLoginClicked_TUI(_ sender: Any) {
      
        if textFieldEmail.text != "" && textFieldPassword.text != "" {
            self.lottieView2.isHidden = false
            self.btnLoginClickedAnimation()
            loginPresenterObject?.login(email: textFieldEmail.text!, password: textFieldPassword.text!)
        }else {
            standartAlert("Uyarı", "Email ve şifre boş bırakılamaz!", .alert, "Tamam", .default)
        }
    }
    
    @IBAction func btnCreateAccountClicked_TUI(_ sender: Any) {
        performSegue(withIdentifier: "sgCreateAccount", sender: nil)
    }
    
}
// MARK: - Extesion

extension VC_Login: PresenterToViewLoginProtocol {
  
    func dataTransferToView(isSuccess: Bool) {
        if isSuccess {
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }else {
            standartAlert("Uyarı", loginPresenterObject?.loginInteractor?.loginContol, .alert, "Tamam", .default)
        }
    }
    
}
