//
//  CartTableViewCell.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import UIKit
import SwiftUI

final class CartTableViewCell: UITableViewCell {
    
    // MARK: - UI ELements
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var btnFoodCount: UIButton!
    @IBOutlet weak var labelFoodCount: UILabel!
    @IBOutlet weak var viewStepper: UIView!
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
  
        viewStepper.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: - UI ELements
    @IBAction func btnSubtractProductClicked_TUI(_ sender: UIButton) {}
    
    @IBAction func btnAddProductClicked_TUI(_ sender: UIButton) {}
    
    @IBAction func btnFoodCount_TUI(_ sender: Any) {}
}
