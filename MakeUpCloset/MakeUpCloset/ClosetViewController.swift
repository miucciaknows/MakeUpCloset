//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit


struct SubItem {
    var name: String
    var brand: String
    var openingDate: Date?
    var expiryDate: Date?
}

struct Item {
    var name: String
    var brand: String
    var subItems: [SubItem]
}

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
   }

   extension ClosetViewController: UITableViewDataSource, UITableViewDelegate {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return itemsToShow.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
           let item = itemsToShow[indexPath.row]
           
           let text = "\(item.name) \(item.brand)\n"
           
           let attributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.gray,
               .font: UIFont.boldSystemFont(ofSize: 18)
           ]
           let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
           
           if expandedIndexes.contains(indexPath.row) {
               if !item.subItems.isEmpty {
                   attributedText.append(NSAttributedString(string: "\n"))
               }
               
               for subItem in item.subItems {
                   let subItemText = NSMutableAttributedString(string: "\(subItem.name) - \(subItem.brand)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
                   attributedText.append(subItemText)
                   

                   let openingDateText = "Opening Date: \(subItem.openingDate.map { dateFormatter.string(from: $0) } ?? "")\n"
                   attributedText.append(NSAttributedString(string: openingDateText))
                   
                   let expiryDateText = "Expiry Date: \(subItem.expiryDate.map { dateFormatter.string(from: $0) } ?? "")\n"
                   attributedText.append(NSAttributedString(string: expiryDateText))
                   
                   attributedText.append(NSAttributedString(string: "\n"))
               }
           }
           
           cell.textLabel?.numberOfLines = 0
           cell.textLabel?.attributedText = attributedText
           cellHeights[indexPath.row] = UITableView.automaticDimension
           
           if expandedIndexes.contains(indexPath.row) {
               let addButton = UIButton(type: .contactAdd)
               addButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
               addButton.tag = indexPath.row
               addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
               cell.accessoryView = addButton
           } else {
               cell.accessoryView = nil
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

       func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if expandedIndexes.contains(indexPath.row) {
               let addButton = UIButton(type: .contactAdd)
               addButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
               addButton.tag = indexPath.row
               addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
               cell.accessoryView = addButton
           } else {
               cell.accessoryView = nil
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
