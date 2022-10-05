//
//  ViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 24.09.2022.
//

import UIKit
import Lottie

class VC_SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = AnimationView(name: "burger")
           animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
       //animationView.frame = view.bounds
            animationView.center = self.view.center
            animationView.contentMode = .scaleAspectFit
            
            view.addSubview(animationView)
        
            animationView.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            let transition: CATransition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            self.view.window!.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)
        })
    }


}

