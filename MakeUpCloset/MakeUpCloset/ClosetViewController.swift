//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit

struct Item {
    var name: String
    var brand: String
}

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var selectedButton: ButtonType?
    var itemsToShow: [String] = []
    var expandedIndexes: Set<Int> = []
    var cellHeights: [CGFloat] = []
    
    @IBOutlet weak var tableContentView: UITableView!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    
      var makeupItems: [Item] = []
      var skincareItems: [Item] = []
      var haircareItems: [Item] = []
      var fragranceItems: [Item] = []
    
      override func viewDidLoad() {
          super.viewDidLoad()
          
          customizeTableView()
          
          switch selectedButton {
          case .make_Up:
              pageLabel.text = "MakeUp"
              itemsToShow = ["Lipstick", "Eyeshadow", "Eyelashes", "Foundation", "Mascara", "Blush"]
              makeupItems = itemsToShow.map { Item(name: $0, brand: "") }
          case .skin_care:
              pageLabel.text = "Skincare"
              itemsToShow = ["Cleanser", "Moisturizer", "Sunscreen", "Serum", "Toner", "Exfoliator"]
              skincareItems = itemsToShow.map { Item(name: $0, brand: "") }
          case .hair_Care:
              pageLabel.text = "Haircare"
              itemsToShow = ["Shampoo", "Conditioner", "Oil", "Mask", "Serum", "Styling Tools"]
              haircareItems = itemsToShow.map { Item(name: $0, brand: "") }
          case .fragrances:
              pageLabel.text = "Fragrances"
              itemsToShow = ["Eau de Toilette", "Eau de Parfum"]
              fragranceItems = itemsToShow.map { Item(name: $0, brand: "") }
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
          let itemName = itemsToShow[indexPath.row]
          cell.textLabel?.text = itemName
          

          if expandedIndexes.contains(indexPath.row) {
              cellHeights[indexPath.row] = 100
          } else {
              cellHeights[indexPath.row] = UITableView.automaticDimension
          }
          
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return cellHeights[indexPath.row]
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          
   
          if expandedIndexes.contains(indexPath.row) {
              expandedIndexes.remove(indexPath.row)
          } else {
              expandedIndexes.insert(indexPath.row)
          }
          
          tableView.reloadRows(at: [indexPath], with: .automatic)
      }
  }
