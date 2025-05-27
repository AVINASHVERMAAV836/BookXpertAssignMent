//
//  ProductTVCell.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 26/05/25.
//

import UIKit

class ProductTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var colorLbl: UILabel!
    @IBOutlet weak var capacityLbl: UILabel!
    @IBOutlet weak var capacityGBLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var generationLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var cpuModelLbl: UILabel!
    @IBOutlet weak var hardDiskSizeLbl: UILabel!
    @IBOutlet weak var strapColourLbl: UILabel!
    @IBOutlet weak var caseSizeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var screenSizeLbl: UILabel!
    @IBOutlet weak var color2Lbl: UILabel!
    @IBOutlet weak var capacity2Lbl: UILabel!
    @IBOutlet weak var generation2Lbl: UILabel!
    @IBOutlet weak var price2Lbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
