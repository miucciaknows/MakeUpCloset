//
//  ClosetControllerTables.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 13/02/24.
//

import Foundation
import UIKit

// MARK: - UITableViewDataSource Methods

extension ClosetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = itemsToShow[indexPath.row]
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: cell.contentView.frame.width - 30, height: 20))
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        titleLabel.textColor = UIColor.gray
        titleLabel.numberOfLines = 1
        titleLabel.text = item.name
        cell.contentView.addSubview(titleLabel)
        
        if expandedIndexes.contains(indexPath.row) {
            var yOffset: CGFloat = 40
            
            for (index, subItem) in item.subItems.enumerated() {
                let nameString = NSMutableAttributedString(string: "\(subItem.name)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)])
                let brandString = NSAttributedString(string: " - \(subItem.brand)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)])
                nameString.append(brandString)
                
                if let openingDate = subItem.openingDate {
                    let openingDateString = DateFormatter.localizedString(from: openingDate, dateStyle: .medium, timeStyle: .none)
                    let openingDateAttribute = NSAttributedString(string: "\nOpening: \(openingDateString)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                    nameString.append(openingDateAttribute)
                }
                
                if let expirationDate = subItem.expirationDate {
                    let expirationDateString = DateFormatter.localizedString(from: expirationDate, dateStyle: .medium, timeStyle: .none)
                    let expirationDateAttribute = NSAttributedString(string: "\nExpiration: \(expirationDateString)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                    nameString.append(expirationDateAttribute)
                }
                
                if let color = subItem.color {
                    let colorAttribute = NSAttributedString(string: "\nColor: \(color)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                    nameString.append(colorAttribute)
                }
                
                if let finish = subItem.finish {
                    let finishAttribute = NSAttributedString(string: "\nFinish: \(finish)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                    nameString.append(finishAttribute)
                }
                
                let subItemLabel = UILabel(frame: CGRect(x: 15, y: yOffset, width: cell.contentView.frame.width - 30, height: 20))
                subItemLabel.attributedText = nameString
                subItemLabel.numberOfLines = 0
                subItemLabel.sizeToFit()
                cell.contentView.addSubview(subItemLabel)
                
                yOffset += subItemLabel.frame.height + 10
                
                if index < item.subItems.count - 1 {
                    let lineView = UIView(frame: CGRect(x: 15, y: yOffset, width: cell.contentView.frame.width - 30, height: 1))
                    lineView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0) // Cinza claro
                    lineView.layer.addBorder(edge: .bottom, color: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0), thickness: 1.0) // Adicionando borda pontilhada
                    cell.contentView.addSubview(lineView)
                    
                    yOffset += 10
                }
            }
            
            let addButton = UIButton(type: .contactAdd)
            addButton.tintColor = UIColor(red: 237/255, green: 179/255, blue: 152/255, alpha: 1.0)
            addButton.tag = indexPath.row
            addButton.addTarget(self, action: #selector(addSubItem(_:)), for: .touchUpInside)
            addButton.frame = CGRect(x: cell.contentView.frame.width - 50, y: 10, width: 40, height: 40)
            cell.contentView.addSubview(addButton)
            
            let removeButton = UIButton(type: .system)
            removeButton.setTitle("-", for: .normal)
            removeButton.tintColor = .red
            removeButton.tag = indexPath.row
            removeButton.addTarget(self, action: #selector(removeSubItem(_:)), for: .touchUpInside)
            removeButton.frame = CGRect(x: cell.contentView.frame.width - 100, y: 10, width: 40, height: 40)
            cell.contentView.addSubview(removeButton)
            
            cellHeights[indexPath.row] = yOffset + 10
        } else {
            cellHeights[indexPath.row] = 40
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate Methods

extension ClosetViewController: UITableViewDelegate {
    
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
