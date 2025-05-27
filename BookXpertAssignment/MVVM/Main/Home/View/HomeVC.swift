//
//  HomeVC.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 24/05/25.
//

import UIKit
import PDFKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var productTV: UITableView!
    
    let productViewModel = ProductViewModel()
    var products: [ProductListData] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        if let productList = self.productViewModel.fetchStoredProducts(){
            products = productList
        }else{
            showAlert(title: "", message: "Data Not available", vc: self)
        }
        
        
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ProfileVC") as? ProfileVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func editProduct(_ sender: UIButton) {
        let index = sender.tag
        let product = products[index]

        let alert = UIAlertController(title: "Edit Product", message: nil, preferredStyle: .alert)

        let fields: [(label: String, value: String?, setter: (String) -> Void)] = [
            ("Name", product.name, { product.name = $0 }),
            ("Color", product.color, { product.color = $0 }),
            ("Capacity", product.capacity, { product.capacity = $0 }),
            ("Capacity GB", product.capacityGB, { product.capacityGB = $0 }),
            ("Price", product.price, { product.price = $0 }),
            ("Generation", product.generation, { product.generation = $0 }),
            ("Year", product.year, { product.year = $0 }),
            ("CPU Model", product.cpuModel, { product.cpuModel = $0 }),
            ("Hard Disk Size", product.hardDiskSize, { product.hardDiskSize = $0 }),
            ("Strap Colour", product.strapColour, { product.strapColour = $0 }),
            ("Case Size", product.caseSize, { product.caseSize = $0 }),
            ("Description", product.descriptionTxt, { product.descriptionTxt = $0 }),
            ("Screen Size", product.screenSize, { product.screenSize = $0 }),
            ("Color", product.color2, { product.color2 = $0 }),
            ("Capacity", product.capacity2, { product.capacity2 = $0 }),
            ("Generation", product.generation2, { product.generation2 = $0 }),
            ("Price", product.price2, { product.price2 = $0 })
        ]

        // Track only non-empty values and store setters to apply on save
        var activeSetters: [(String) -> Void] = []

        for field in fields {
            if let value = field.value, !value.isEmpty {
                alert.addTextField { textField in
                    textField.placeholder = field.label
                    textField.text = value
                }
                activeSetters.append(field.setter)
            }
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            for (i, setter) in activeSetters.enumerated() {
                let text = alert.textFields?[i].text ?? ""
                setter(text)
            }

            self.productViewModel.saveContext()
            self.productTV.reloadData()
        }))

        present(alert, animated: true)
    }

    
   
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTV.dequeueReusableCell(withIdentifier: "ProductTVCell") as! ProductTVCell

        let product = products[indexPath.row]
        setLabel(cell.nameLbl, with: product.name, tagtxt: "")
        setLabel(cell.colorLbl, with: product.color, tagtxt: "Color: ")
        setLabel(cell.capacityLbl, with: product.capacity, tagtxt: "Capacity: ")
        setLabel(cell.capacityGBLbl, with: product.capacityGB, tagtxt: "Capacity GB: ")
        setLabel(cell.priceLbl, with: product.price, tagtxt: "Price: ")
        setLabel(cell.generationLbl, with: product.generation, tagtxt: "Generation: ")
        setLabel(cell.yearLbl, with: product.year, tagtxt: "Year: ")
        setLabel(cell.cpuModelLbl, with: product.cpuModel, tagtxt: "CPU model: ")
        setLabel(cell.hardDiskSizeLbl, with: product.hardDiskSize, tagtxt: "Hard disk size: ")
        setLabel(cell.strapColourLbl, with: product.strapColour, tagtxt: "Strap Color: ")
        setLabel(cell.caseSizeLbl, with: product.caseSize, tagtxt: "Case Size: ")
        setLabel(cell.descriptionLbl, with: product.descriptionTxt, tagtxt: "Description: ")
        setLabel(cell.screenSizeLbl, with: product.screenSize, tagtxt: "Screen size: ")
        setLabel(cell.color2Lbl, with: product.color2, tagtxt: "Color: ")
        setLabel(cell.capacity2Lbl, with: product.capacity2, tagtxt: "Capacity: ")
        setLabel(cell.generation2Lbl, with: product.generation2, tagtxt: "Generation: ")
        setLabel(cell.price2Lbl, with: product.price2, tagtxt: "Price: ")
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editProduct(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if products.count > 0 {
                let productToDelete = products[indexPath.row]
            
                products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Send notification if enabled
                let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                if notificationsEnabled {
                    sendDeletionNotification(for: productToDelete)
                }
                // Delete from context and update UI
                self.productViewModel.deleteProduct(productToDelete)
                self.productViewModel.saveContext()
            }
        }
    }

    
    func sendDeletionNotification(for product: ProductListData) {
        let center = UNUserNotificationCenter.current()
        // Only fields with non-empty values will be included
            let fields: [(label: String, value: String?)] = [
                ("Name", product.name),
                ("Color", product.color),
                ("Capacity", product.capacity),
                ("Capacity GB", product.capacityGB),
                ("Price", product.price),
                ("Generation", product.generation),
                ("Year", product.year),
                ("CPU Model", product.cpuModel),
                ("Hard Disk Size", product.hardDiskSize),
                ("Strap Colour", product.strapColour),
                ("Case Size", product.caseSize),
                ("Description", product.descriptionTxt),
                ("Screen Size", product.screenSize),
                ("Color", product.color2),
                ("Capacity", product.capacity2),
                ("Generation", product.generation2),
                ("Price", product.price2)
            ]
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                var body = ""

                   for field in fields {
                       if let value = field.value, !value.isEmpty {
                           body += "\(field.label): \(value)\n"
                       }
                   }
                let content = UNMutableNotificationContent()
                content.title = "Product Deleted"
                content.body = body.isEmpty ? "No details available." : body
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request)
                
            } else {
                print("if Permission denied. Please go to Settings > Notifications.")
            }
        }
    }
   

    func setLabel(_ label: UILabel, with text: String?, tagtxt: String) {
        if let text = text, !text.isEmpty {
            label.text = "\(tagtxt)\(text)"
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }


}



