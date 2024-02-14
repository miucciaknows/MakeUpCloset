//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit


class ClosetViewController: UIViewController {
    
    
    var selectedButton: ButtonType?
    var itemsToShow: [Item] = []
    var expandedIndexes: Set<Int> = []
    var cellHeights: [CGFloat] = []
    
    
    @IBOutlet weak var tableContentView: UITableView!
    @IBOutlet weak var pageLabel: UILabel!
    
    
    
       override func viewDidLoad() {
           super.viewDidLoad()
           customizeTableView()
           loadData()
       }
       
       private func customizeTableView() {
           tableContentView.layer.borderWidth = 1.0
           tableContentView.layer.borderColor = UIColor.lightGray.cgColor
           tableContentView.layer.cornerRadius = 8.0
       }
       
       private func loadData() {
           switch selectedButton {
           case .make_Up:
               pageLabel.text = "MakeUp"
               itemsToShow = [
                   Item(name: "Lipstick", brand: "", subItems: []),
                   Item(name: "Eyeshadow", brand: "", subItems: []),
                   Item(name: "Eyelashes", brand: "", subItems: []),
                   Item(name: "Foundation", brand: "", subItems: []),
                   Item(name: "Mascara", brand: "", subItems: []),
                   Item(name: "Blush", brand: "", subItems: [])
               ]
           case .skin_care:
               pageLabel.text = "Skincare"
               itemsToShow = [
                   Item(name: "Cleanser", brand: "", subItems: []),
                   Item(name: "Moisturizer", brand: "", subItems: []),
                   Item(name: "Sunscreen", brand: "", subItems: []),
                   Item(name: "Serum", brand: "", subItems: []),
                   Item(name: "Toner", brand: "", subItems: []),
                   Item(name: "Exfoliator", brand: "", subItems: [])
               ]
           case .hair_Care:
               pageLabel.text = "Haircare"
               itemsToShow = [
                   Item(name: "Shampoo", brand: "", subItems: []),
                   Item(name: "Conditioner", brand: "", subItems: []),
                   Item(name: "Oil", brand: "", subItems: []),
                   Item(name: "Mask", brand: "", subItems: []),
                   Item(name: "Serum", brand: "", subItems: []),
                   Item(name: "Styling Tools", brand: "", subItems: [])
               ]
           case .fragrances:
               pageLabel.text = "Fragrances"
               itemsToShow = [
                   Item(name: "Eau de Toilette", brand: "", subItems: []),
                   Item(name: "Eau de Parfum", brand: "", subItems: [])
               ]
           case nil:
               break
           }
           
           for _ in itemsToShow {
               cellHeights.append(UITableView.automaticDimension)
           }
           
           tableContentView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
           tableContentView.dataSource = self
           tableContentView.delegate = self
           tableContentView.reloadData()
           
           loadSubItemsFromUserDefaults()
       }
       
       func saveSubItemsToUserDefaults() {
           for (index, item) in itemsToShow.enumerated() {
               let key = "\(pageLabel.text ?? "")_\(index)_SubItems"
               if let subItemsData = try? JSONEncoder().encode(item.subItems) {
                   UserDefaults.standard.set(subItemsData, forKey: key)
               }
           }
       }
       
       func loadSubItemsFromUserDefaults() {
           for (index, item) in itemsToShow.enumerated() {
               let key = "\(pageLabel.text ?? "")_\(index)_SubItems"
               if let subItemsData = UserDefaults.standard.data(forKey: key),
                  let savedSubItems = try? JSONDecoder().decode([SubItem].self, from: subItemsData) {
                   itemsToShow[index].subItems = savedSubItems
               }
           }
       }
   }

  
   

   
