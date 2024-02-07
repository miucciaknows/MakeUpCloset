//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit


class Brand {
    let name: String
    var items: [Item]
    
    init(name: String) {
        self.name = name
        self.items = []
    }
}

class Item {
    let name: String
    let type: String
    var quantity: Int
    
    init(name: String, type: String, quantity: Int) {
        self.name = name
        self.type = type
        self.quantity = quantity
    }
}

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedButton: ButtonType?
    var brands: [Brand] = []
    
    @IBOutlet weak var tableContentView: UITableView!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    enum Section {
          case brand
      }
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeTableView()
        
        
        switch selectedButton {
        case .make_Up:
            pageLabel.text = "MakeUp"
        case .skin_care:
            pageLabel.text = "Skincare"
            
        case .hair_Care:
            pageLabel.text = "Haircare"
        case .fragrances:
            pageLabel.text = "Fragrances"
        case nil:
            break
        }
        
        
        
    }
    
    private func customizeTableView() {
        tableContentView.layer.borderWidth = 1.0
        tableContentView.layer.borderColor = UIColor.lightGray.cgColor
        tableContentView.layer.cornerRadius = 8.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return brands.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath)
           
           let brand = brands[indexPath.row]
           cell.textLabel?.text = brand.name
           return cell
       }
       
       @IBAction func addBrand(_ sender: Any) {
           let alertController = UIAlertController(title: "Add Brand", message: "Enter the brand name", preferredStyle: .alert)
           alertController.addTextField { textField in
               textField.placeholder = "Brand Name"
           }
           
           let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
               guard let brandName = alertController.textFields?.first?.text, !brandName.isEmpty else { return }
               let newBrand = Brand(name: brandName)
               self?.brands.append(newBrand)
               self?.tableContentView.reloadData()
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(addAction)
           alertController.addAction(cancelAction)
           present(alertController, animated: true, completion: nil)
       }
   }
