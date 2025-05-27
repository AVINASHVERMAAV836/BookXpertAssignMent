//
//  ProductViewModel.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 25/05/25.
//

import Foundation
import CoreData

protocol ProductViewModelProtocol {
    func saveDataToCoreData(isSaved: Bool)
}


struct ProductViewModel{
    
    var delegate: ProductViewModelProtocol?
    
    func getProducts(url: String) {
        guard let urlString = URL(string: url) else{
            print("Url is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            if let data = data{
                do{
                    
                    let productData = try JSONDecoder().decode([ProductList].self, from: data)
                    saveProductsToCoreData(productData)
                    
                }catch let error{
                    print(error)
                }
                
            }else{
                print("data is nil")
            }
            
        }.resume()
    }
    
    func saveProductsToCoreData(_ products: [ProductList]) {
        for product in products {
            let fetchRequest: NSFetchRequest<ProductListData> = ProductListData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
            print(product)
            do {
                let existing = try context.fetch(fetchRequest)
                if existing.isEmpty {
                    let entity = ProductListData(context: context)
                    entity.id = product.id
                    entity.name = product.name
                    entity.color = product.data?.color ?? ""
                    entity.capacity = product.data?.capacity ?? ""
                    entity.price = "\(product.data?.price ?? 0.0)"
                    entity.capacityGB = "\(product.data?.capacityGB ?? 0)"
                    entity.generation = product.data?.generation ?? ""
                    entity.year = "\(product.data?.year ?? 0)"
                    entity.cpuModel = product.data?.cpuModel ?? ""
                    entity.hardDiskSize = product.data?.hardDiskSize ?? ""
                    entity.strapColour = product.data?.strapColour ?? ""
                    entity.caseSize = product.data?.caseSize ?? ""
                    entity.descriptionTxt = product.data?.description ?? ""
                    entity.screenSize = "\(product.data?.screenSize ?? 0.0)"
                    entity.color2 = product.data?.Color ?? ""
                    entity.capacity2 = product.data?.Capacity ?? ""
                    entity.generation2 = product.data?.Generation ?? ""
                    entity.price2 = product.data?.Price ?? ""
                } else {
                    print("Product with id \(product.id) already exists.")
                }
            } catch {
                print("Fetch failed for product id \(product.id): \(error)")
            }
        }
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
            delegate?.saveDataToCoreData(isSaved: true)
        } catch {
            print("Core Data save error: \(error)")
        }
    }
    
    
    func deleteProduct(_ productEntity: ProductListData) {
        context.delete(productEntity)
        saveContext()
    }
    
    func fetchStoredProducts() -> [ProductListData]? {
        let request: NSFetchRequest<ProductListData> = ProductListData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
}
