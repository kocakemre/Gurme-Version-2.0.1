//
//  TableViewCell_Cart.swift
//  Gurme
//
//  Created by Emre Kocak on 2.10.2022.
//

import UIKit
import SwiftUI


class TableViewCell_Cart: UITableViewCell {

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
        // Initialization code
        viewStepper.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  

    // MARK: - UI ELements
    @IBAction func btnSubtractProductClicked_TUI(_ sender: UIButton) {
      
    }
    
    @IBAction func btnAddProductClicked_TUI(_ sender: UIButton) {
        
    }
    
    @IBAction func btnFoodCount_TUI(_ sender: Any) {
    }
}
