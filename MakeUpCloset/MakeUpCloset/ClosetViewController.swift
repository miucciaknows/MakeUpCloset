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
}

struct Item {
    var name: String
    var brand: String
    var subItems: [SubItem]
}

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedButton: ButtonType?
    var itemsToShow: [Item] = []
    var expandedIndexes: Set<Int> = []
    var cellHeights: [CGFloat] = []
    @IBOutlet weak var tableContentView: UITableView!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         customizeTableView()
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
        
        if expandedIndexes.contains(indexPath.row) {
            var text = item.name + "\n"
            for subItem in item.subItems {
                text += "\(subItem.name) - \(subItem.brand)\n"
            }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = text
            cellHeights[indexPath.row] = UITableView.automaticDimension
            

            let addButton = UIButton(type: .contactAdd)
            addButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
            addButton.tag = indexPath.row
            addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
            cell.accessoryView = addButton
        } else {
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.text = item.name
            cellHeights[indexPath.row] = UITableView.automaticDimension
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
        if let addButton = cell.accessoryView as? UIButton {
            addButton.removeTarget(nil, action: nil, for: .allEvents)
            addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
        }
    }

     
     @objc func editSubItems(_ sender: UITapGestureRecognizer) {
         guard let tappedCell = sender.view as? UITableViewCell,
               let indexPath = tableContentView.indexPath(for: tappedCell) else {
             return
         }
         
         let alertController = UIAlertController(title: "Edit SubItems", message: nil, preferredStyle: .alert)
         alertController.addTextField { textField in
             textField.placeholder = "Enter new item name"
         }
         alertController.addTextField { textField in
             textField.placeholder = "Enter new item brand"
         }
         let addAction = UIAlertAction(title: "Add", style: .default) { _ in
             guard let name = alertController.textFields?[0].text,
                   let brand = alertController.textFields?[1].text else {
                 return
             }
             let newItem = SubItem(name: name, brand: brand)
             self.itemsToShow[indexPath.row].subItems.append(newItem)
             self.tableContentView.reloadData()
         }
         alertController.addAction(addAction)
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         
         present(alertController, animated: true, completion: nil)
     }
     
    @objc func addSubItem(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add SubItem", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter subitem name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter subitem brand"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alertController.textFields?[0].text,
                  let brand = alertController.textFields?[1].text else {
                return
            }
            
            let cellIndex = sender.tag
            let newItem = SubItem(name: name, brand: brand)
            self.itemsToShow[cellIndex].subItems.append(newItem)
            self.tableContentView.reloadData()
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

 }
