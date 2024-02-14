//
//  ClosetController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 13/02/24.
//

import Foundation
import UIKit

// MARK: - SubItem Actions

extension ClosetViewController {
    
    @objc func addSubItem(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add SubItem", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter subitem name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter subitem brand"
        }
        
        // Adicionando campos específicos para maquiagem
        if selectedButton == .make_Up {
            alertController.addTextField { textField in
                textField.placeholder = "Enter color (Optional)"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Enter finish (Optional)"
            }
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter opening date: YYYY/DD/MM"
            textField.inputView = nil
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter expiration date: YYYY/DD/MM"
            textField.inputView = nil
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alertController.textFields?[0].text,
                  let brand = alertController.textFields?[1].text else {
                return
            }
            
            let cellIndex = sender.tag
            let openingDateText = alertController.textFields?[2 + (self.selectedButton == .make_Up ? 2 : 0)].text
            let expirationDateText = alertController.textFields?[3 + (self.selectedButton == .make_Up ? 2 : 0)].text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/dd/MM"
            
            let openingDate = dateFormatter.date(from: openingDateText ?? "")
            let expirationDate = dateFormatter.date(from: expirationDateText ?? "")
            
            var color: String?
            var finish: String?
            
            if self.selectedButton == .make_Up {
                color = alertController.textFields?[2].text
                finish = alertController.textFields?[3].text
            }
            
            let newItem = SubItem(name: name, brand: brand, color: color,
                                  finish: finish,
                                  openingDate: openingDate,
                                  expirationDate: expirationDate)
            
            self.itemsToShow[cellIndex].subItems.append(newItem)
            
        
            self.cellHeights[cellIndex] = UITableView.automaticDimension
            
      
            self.tableContentView.reloadRows(at: [IndexPath(row: cellIndex, section: 0)], with: .none)
            
            self.saveSubItemsToUserDefaults()
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func removeSubItem(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Remove SubItem", message: "Choose subitem to remove", preferredStyle: .actionSheet)
        
        let itemIndex = sender.tag
        let subItems = itemsToShow[itemIndex].subItems
        
        for (index, subItem) in subItems.enumerated() {
            let action = UIAlertAction(title: "\(subItem.name) - \(subItem.brand)", style: .default) { _ in
                self.itemsToShow[itemIndex].subItems.remove(at: index)
                self.tableContentView.reloadData()
                self.saveSubItemsToUserDefaults()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
