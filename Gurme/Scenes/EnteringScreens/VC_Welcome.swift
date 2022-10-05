//
//  VC_Welcome.swift
//  Gurme
//
//  Created by Emre Kocak on 28.09.2022.
//

import UIKit
import Lottie

class VC_Welcome: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var welcomeView: UIView!
   
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.welcomeAnimation()
        self.customView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.welcomeAnimation()
        self.customView()
    }
    
    
    
    // MARK: - Methods
    
    func customView() {
        welcomeView.layer.shadowColor = UIColor.systemGray2.cgColor
        welcomeView.layer.shadowOpacity = 1
        welcomeView.layer.shadowOffset = .zero
        welcomeView.layer.shadowRadius = 10
        
        welcomeView.layer.shadowPath = UIBezierPath(rect: welcomeView.bounds).cgPath
        welcomeView.layer.shouldRasterize = true
        welcomeView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func welcomeAnimation() {
       
        let animation = Animation.named("hii")
        lottieView.animation = animation
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        
        if (!lottieView.isAnimationPlaying){
            lottieView.play()
        }
    }
  
    @IBAction func btnLoginClicked_TUI(_ sender: Any) {
        performSegue(withIdentifier: "sgLogin", sender: nil)
    }
    
    @IBAction func btnCreateAccountClicked_TUI(_ sender: Any) {
        performSegue(withIdentifier: "sgRegister", sender: nil)
    }
}
