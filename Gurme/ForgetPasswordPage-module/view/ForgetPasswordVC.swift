//
//  ForgetPasswordVC.swift
//  Gurme
//
//  Created by Emre Kocak on 28.09.2022.
//

import UIKit
import Lottie

final class ForgetPasswordVC: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet private weak var lottieView: AnimationView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.title = "Şifreyi Yenile"
        
        self.forgetPasswordAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Şifreyi Yenile"
        self.forgetPasswordAnimation()
    }
}

// MARK: - Action Methods
private
extension ForgetPasswordVC {
    
    @IBAction func btnResetPassword_TUI(_ sender: Any) {
        self.alertLogin()
    }
}

// MARK: - Private Methods
private
extension ForgetPasswordVC {
    
    func forgetPasswordAnimation() {
        
        let animation = Animation.named("lock")
        lottieView.animation = animation
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        
        if (!lottieView.isAnimationPlaying) {
            lottieView.play()
        }
    }
    
    func alertLogin() {
        let alertController = UIAlertController(
            title: "Uyarı",
            message: "Lütfen mailinizi ve spam kutunuzu kontrol ediniz.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
