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
        
        cell.accessoryView = nil
        
        if expandedIndexes.contains(indexPath.row) {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            
            let addButton = UIButton(type: .contactAdd)
            addButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
            addButton.tag = indexPath.row
            addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
            
            let subtractButton = UIButton(type: .contactAdd)
            subtractButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
            subtractButton.tag = indexPath.row
            subtractButton.addTarget(self, action: #selector(subtractSubItem(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(addButton)
            stackView.addArrangedSubview(subtractButton)
            
            cell.accessoryView = stackView
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
            let addButton = UIButton(type: .system)
            addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            addButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
            addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
            
            let subtractButton = UIButton(type: .system)
            subtractButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            subtractButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
            subtractButton.addTarget(self, action: #selector(subtractSubItem(_:)), for: .touchUpInside)
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
            containerView.addSubview(addButton)
            containerView.addSubview(subtractButton)
            
            addButton.translatesAutoresizingMaskIntoConstraints = false
            subtractButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                addButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                addButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                addButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
                addButton.widthAnchor.constraint(equalToConstant: 30),
                
                subtractButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8),
                subtractButton.widthAnchor.constraint(equalTo: addButton.widthAnchor), // Ambos os botões têm a mesma largura
                subtractButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                subtractButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                subtractButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ])
            
            cell.accessoryView = containerView
        } else {
            cell.accessoryView = nil
        }
    }

    
}

