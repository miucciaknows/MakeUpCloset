//
//  TableViewExtensions.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 09/02/24.
//

import Foundation
import UIKit

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
    
}

