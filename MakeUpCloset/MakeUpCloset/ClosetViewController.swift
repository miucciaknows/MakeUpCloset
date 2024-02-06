//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedButton: choosenButton?
    var brands: [String] = []
    
    @IBOutlet weak var tableContentView: UITableView!

    @IBOutlet weak var pageLabel: UILabel!
    
    enum Section {
        case brand
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBrands()
        
        switch selectedButton {
        case .make_Up:
            pageLabel.text = "Makeup"
        case .skin_Care_Option:
            pageLabel.text = "Skincare"
        case .hair_Care:
            pageLabel.text = "HairCare"
        case .fragrances:
            pageLabel.text = "Fragrances"
        default:
            break
        }
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath)
            
        let brand = brands[indexPath.row]
        cell.textLabel?.text = brand
        return cell
        }
    
    private func loadBrands() {
        
         brands = ["Brand A", "Brand B", "Brand C"]
         tableContentView.reloadData()
     }

    @IBAction func addBrand(_ sender: Any) {
         let alertController = UIAlertController(title: "Add Brand", message: "Enter the brand name", preferredStyle: .alert)
         alertController.addTextField { textField in
             textField.placeholder = "Brand Name"
         }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let brandName = alertController.textFields?.first?.text, !brandName.isEmpty else { return }
                   self?.brands.append(brandName)
                   self?.tableContentView.reloadData()
               }
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               alertController.addAction(addAction)
               alertController.addAction(cancelAction)
               present(alertController, animated: true, completion: nil)
           }
        
 
    }

