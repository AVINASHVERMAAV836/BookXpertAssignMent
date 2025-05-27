//
//  DataModel.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 25/05/25.
//

import Foundation
import UIKit


struct ProductList: Codable {
    var id: String
    var name: String
    var data: ProductData?
}

// MARK: - Product Data (Flexible model)
struct ProductData: Codable {
    var color: String?
    var capacity: String?
    var capacityGB: Int?
    var price: Double?
    var generation: String?
    var year: Int?
    var cpuModel: String?
    var hardDiskSize: String?
    var strapColour: String?
    var caseSize: String?
    var description: String?
    var screenSize: Double?
    var Color: String?
    var Capacity: String?
    var Generation: String?
    var Price: String?

    enum CodingKeys: String, CodingKey {
        case color
        case capacity
        case capacityGB = "capacity GB"
        case price
        case generation
        case year
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case description = "Description"
        case screenSize = "Screen size"
        case Color
        case Capacity
        case Generation
        case Price
    }
}



//MARK: Save Login session.......................................
var isLogin : Bool{
    set{
        UserDefaults.standard.setValue(newValue, forKey: "isLogin")
        UserDefaults.standard.synchronize()
    }
    
    get{
        if let token = UserDefaults.standard.value(forKey: "isLogin") as? Bool{
            return token
        }else{
            return false
        }
    }
}


//MARK: Common alert .......................................
func showAlert(title: String, message: String, vc: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    vc.present(alert, animated: true)
}

