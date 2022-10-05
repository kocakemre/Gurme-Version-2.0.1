//
//  CollectionViewCell_OnBoarding.swift
//  Gurme
//
//  Created by Emre Kocak on 25.09.2022.
//

import UIKit
import Lottie

class CollectionViewCell_OnBoarding: UICollectionViewCell {
    
  // MARK: - UI Elements
    
    @IBOutlet weak var btnOutlet: UIButton!
    @IBOutlet weak var labelChild: UILabel!
    @IBOutlet weak var labelHead: UILabel!
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var pageContol: UIPageControl!
    
    static let identifierCell = String(describing: CollectionViewCell_OnBoarding.self)
    
    var btnActionTap: (() -> Void)?
    
    // MARK: - Life Cycles

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Methods

    
    @IBAction func btnAction(_ sender: Any) {
        btnActionTap?()
    }
    
    func configureCell(_ slide: OnBoardingSlide) {
        //btnOutlet.backgroundColor = UIColor(named: slide.btnColor)
        btnOutlet.backgroundColor = slide.btnColor
        btnOutlet.setTitle(slide.btnTitle, for: .normal)
        labelChild.text = slide.titleChild
        labelHead.text = slide.titleHead
        //imageView.image = UIImage(named: slide.animationName)
        
        let animation = Animation.named("\(slide.animationName)")
        lottieView.animation = animation
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        
        if (!lottieView.isAnimationPlaying){
            lottieView.play()
        }
    }
    
}
