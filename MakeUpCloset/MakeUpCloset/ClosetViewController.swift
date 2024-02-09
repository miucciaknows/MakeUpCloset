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
       var itemsToShow: [BeautyItem] = []
       var expandedIndexes: Set<Int> = []
       var cellHeights: [CGFloat] = []
    @IBOutlet weak var tableContentView: UITableView!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    
      lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "YYYY-MM-DD"
          return formatter
      }()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          customizeTableView()
          configureItemsToShow()
          setupTableView()
          loadItemsFromUserDefaults()
      }
      
      private func customizeTableView() {
          tableContentView.layer.borderWidth = 1.0
          tableContentView.layer.borderColor = UIColor.lightGray.cgColor
          tableContentView.layer.cornerRadius = 8.0
      }
      
      private func configureItemsToShow() {
          switch selectedButton {
          case .make_Up:
              pageLabel.text = "MakeUp"
              itemsToShow = [
                  MakeUpItem(name: "Lipstick", brand: "", color: "", openingDate: nil, expiryDate: nil),
                  MakeUpItem(name: "Eyeshadow", brand: "", color: "", openingDate: nil, expiryDate: nil),
                  MakeUpItem(name: "Eyelashes", brand: "", color: "", openingDate: nil, expiryDate: nil),
                  MakeUpItem(name: "Foundation", brand: "", color: "", openingDate: nil, expiryDate: nil),
                  MakeUpItem(name: "Mascara", brand: "", color: "", openingDate: nil, expiryDate: nil),
                  MakeUpItem(name: "Blush", brand: "", color: "", openingDate: nil, expiryDate: nil)
              ]
          case .skin_care:
              pageLabel.text = "Skincare"
              itemsToShow = [
                  SkincareItem(name: "Cleanser", brand: ""),
                  SkincareItem(name: "Moisturizer", brand: ""),
                  SkincareItem(name: "Sunscreen", brand: ""),
                  SkincareItem(name: "Serum", brand: ""),
                  SkincareItem(name: "Toner", brand: ""),
                  SkincareItem(name: "Exfoliator", brand: "")
              ]
          case .hair_Care:
              pageLabel.text = "Haircare"
              itemsToShow = [
                  HairCareItem(name: "Shampoo", brand: ""),
                  HairCareItem(name: "Conditioner", brand: ""),
                  HairCareItem(name: "Oil", brand: ""),
                  HairCareItem(name: "Mask", brand: ""),
                  HairCareItem(name: "Serum", brand: ""),
                  HairCareItem(name: "Styling Tools", brand: "")
              ]
          case .fragrances:
              pageLabel.text = "Fragrances"
              itemsToShow = [
                  FragranceItem(name: "Eau de Toilette", brand: ""),
                  FragranceItem(name: "Eau de Parfum", brand: "")
              ]
          case nil:
              break
          }
          
          for _ in itemsToShow {
              cellHeights.append(UITableView.automaticDimension)
          }
      }
      
      private func setupTableView() {
          tableContentView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
          tableContentView.dataSource = self
          tableContentView.delegate = self
          tableContentView.reloadData()
      }
      
      func saveItemsToUserDefaults() {
          let itemsAsDictionaries: [[String: Any]] = itemsToShow.map { item in
              var itemDictionary: [String: Any] = [
                  "name": item.name,
                  "brand": item.brand,
                  "subItems": item.subItems.map { subItem in
                      return [
                          "name": subItem.name,
                          "brand": subItem.brand,
                          "openingDate": subItem.openingDate ?? "",
                          "expiryDate": subItem.expiryDate ?? ""
                      ]
                  }
              ]
              
              if let makeupItem = item as? MakeUpItem {
                  itemDictionary["color"] = makeupItem.color
              }
              return itemDictionary
          }
          
          UserDefaults.standard.set(itemsAsDictionaries, forKey: "savedItems")
          
          UserDefaults.standard.synchronize()
      }
      
      func loadItemsFromUserDefaults() {
          if let savedItems = UserDefaults.standard.array(forKey: "savedItems") as? [[String: Any]] {
              itemsToShow = savedItems.map { itemDict in
                  let subItems = (itemDict["subItems"] as? [[String: Any]] ?? []).map { subItemDict in
                      return SubItem(
                          name: subItemDict["name"] as? String ?? "",
                          brand: subItemDict["brand"] as? String ?? "",
                          openingDate: subItemDict["openingDate"] as? Date,
                          expiryDate: subItemDict["expiryDate"] as? Date
                      )
                  }
                  let item: BeautyItem
                  if let color = itemDict["color"] as? String {
                      item = MakeUpItem(
                          name: itemDict["name"] as? String ?? "",
                          brand: itemDict["brand"] as? String ?? "",
                          color: color,
                          openingDate: nil,
                          expiryDate: nil,
                          subItems: subItems
                      )
                  } else {
                      item = SkincareItem(
                          name: itemDict["name"] as? String ?? "",
                          brand: itemDict["brand"] as? String ?? "",
                          subItems: subItems
                      )
                  }
                  return item
              }
          }
      }
       
       @objc func addSubItem(_ sender: UIButton) {
               let alertController = UIAlertController(title: "Add SubItem", message: nil, preferredStyle: .alert)
               alertController.addTextField { textField in
                   textField.placeholder = "Enter subitem name"
               }
               alertController.addTextField { textField in
                   textField.placeholder = "Enter subitem brand"
               }
               alertController.addTextField { textField in
                   textField.placeholder = "Enter opening date (YYYY-MM-DD)"
               }
               alertController.addTextField { textField in
                   textField.placeholder = "Enter expiry date (YYYY-MM-DD)"
               }
               
               if selectedButton == .make_Up {
                   alertController.addTextField { textField in
                       textField.placeholder = "Enter subitem color"
                   }
               }
               
               let addAction = UIAlertAction(title: "Add", style: .default) { _ in
                   guard let name = alertController.textFields?[0].text,
                         let brand = alertController.textFields?[1].text,
                         let openingDateString = alertController.textFields?[2].text,
                         let expiryDateString = alertController.textFields?[3].text,
                         !name.isEmpty, !brand.isEmpty else {
                       return
                   }
                   
                   var color: String?
                   var openingDate: Date?
                   var expiryDate: Date?
                   
                   if self.selectedButton == .make_Up {
                       color = alertController.textFields?[4].text
                       openingDate = self.dateFormatter.date(from: openingDateString)
                       expiryDate = self.dateFormatter.date(from: expiryDateString)
                   } else {
                       openingDate = self.dateFormatter.date(from: openingDateString)
                       expiryDate = self.dateFormatter.date(from: expiryDateString)
                   }
                   
                   let newSubItem = SubItem(name: name, brand: brand, openingDate: openingDate, expiryDate: expiryDate)
                   
                   if let buttonPosition = sender.superview?.convert(sender.frame.origin, to: self.tableContentView),
                      let indexPath = self.tableContentView.indexPathForRow(at: buttonPosition) {
                       self.itemsToShow[indexPath.row].subItems.append(newSubItem)
                       if self.selectedButton == .make_Up {
                           if let makeupItem = self.itemsToShow[indexPath.row] as? MakeUpItem {
                               makeupItem.color = color ?? ""
                               makeupItem.openingDate = openingDate
                               makeupItem.expiryDate = expiryDate
                           }
                       }
                       self.tableContentView.reloadRows(at: [indexPath], with: .automatic)
                       
      
                       self.saveItemsToUserDefaults()
                   }
               }
               
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               alertController.addAction(addAction)
               alertController.addAction(cancelAction)
               
               present(alertController, animated: true, completion: nil)
           }
           

           private func getSubItemIndexes(for parentIndex: Int) -> Set<Int>? {
               guard parentIndex >= 0 && parentIndex < itemsToShow.count else {
                   return nil
               }
               
               let subItemsCount = itemsToShow[parentIndex].subItems.count
               guard subItemsCount > 0 else {
                   return nil
               }
               
               var subItemIndexes = Set<Int>()
               for i in 1...subItemsCount {
                   subItemIndexes.insert(parentIndex + i)
               }
               
               return subItemIndexes
           }
       }
