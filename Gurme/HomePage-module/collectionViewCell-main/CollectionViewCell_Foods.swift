//
//  CollectionViewCell_Foods.swift
//  Gurme
//
//  Created by Emre Kocak on 30.09.2022.
//

import UIKit

class CollectionViewCell_Foods: UICollectionViewCell {
    
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewFavorite: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    static var productInfo: DetailPageEntity?
    var favoriteBtnIsTapped:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewFavorite.image = UIImage(named: "favoriteIconEmpty")
    }
    
    
    @IBAction func btnFavoriteClicked_TUI(_ sender: Any) {
        if favoriteBtnIsTapped == true {
            imageViewFavorite.image = UIImage(named: "favoriIconFull")
            favoriteBtnIsTapped = false
        }else {
            imageViewFavorite.image = UIImage(named: "favoriteIconEmpty")
        }
    }
    
}
