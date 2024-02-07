//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit


class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedButton: ButtonType?
    var brands: [String] = ["Brand A", "Brand B", "Brand C"]
    
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
        
        tableContentView.register(UITableViewCell.self, forCellReuseIdentifier: "AddBrandCell")


        tableContentView.register(UITableViewCell.self, forCellReuseIdentifier: "BrandCell")
          

        tableContentView.dataSource = self
        
        
        
    }
    
    private func customizeTableView() {
            tableContentView.layer.borderWidth = 1.0
            tableContentView.layer.borderColor = UIColor.lightGray.cgColor
            tableContentView.layer.cornerRadius = 8.0
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return brands.count + 1
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if indexPath.row == 0 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "AddBrandCell", for: indexPath)
               return cell
           } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath)
               let brand = brands[indexPath.row - 1]
               cell.textLabel?.text = brand
               return cell
           }
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if indexPath.row == 0 {
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
   }
