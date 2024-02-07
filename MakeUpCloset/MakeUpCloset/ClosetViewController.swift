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
    
    var itemsToShow: [String] = []
    
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
            itemsToShow = ["Lipstick", "Eyeshadow", "Eyelashes", "Foundation", "Mascara", "Blush"]
        case .skin_care:
            pageLabel.text = "Skincare"
            itemsToShow = ["Cleanser", "Moisturizer", "Sunscreen", "Serum", "Toner", "Exfoliator"]
            
        case .hair_Care:
            pageLabel.text = "Haircare"
            itemsToShow = ["Shampoo", "Conditioner", "Hair Oil", "Hair Mask", "Hair Serum", "Styling Tools"]
        case .fragrances:
            pageLabel.text = "Fragrances"
            itemsToShow = ["Eau de Toilette", "Eau de Parfum"]
            
        case nil:
            break
        }
        
        
        
        //tableContentView.register(UITableViewCell.self, forCellReuseIdentifier: "AddBrandCell")

    

        tableContentView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
                
  
        tableContentView.dataSource = self
        
        
    }
    
    
       private func customizeTableView() {
           tableContentView.layer.borderWidth = 1.0
           tableContentView.layer.borderColor = UIColor.lightGray.cgColor
           tableContentView.layer.cornerRadius = 8.0
       }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemsToShow.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            let item = itemsToShow[indexPath.row]
            cell.textLabel?.text = item
            return cell
        }
    }
