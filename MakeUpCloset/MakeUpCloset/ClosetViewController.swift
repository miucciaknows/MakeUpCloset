//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit



struct SubItem: Codable {
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
      
    
      private func saveSubItemsToUserDefaults() {
          for (index, item) in itemsToShow.enumerated() {
              let key = "\(pageLabel.text ?? "")_\(index)_SubItems"
              if let subItemsData = try? JSONEncoder().encode(item.subItems) {
                  UserDefaults.standard.set(subItemsData, forKey: key)
              }
          }
      }
      
   
      private func loadSubItemsFromUserDefaults() {
          for (index, item) in itemsToShow.enumerated() {
              let key = "\(pageLabel.text ?? "")_\(index)_SubItems"
              if let subItemsData = UserDefaults.standard.data(forKey: key),
                 let savedSubItems = try? JSONDecoder().decode([SubItem].self, from: subItemsData) {
                  itemsToShow[index].subItems = savedSubItems
              }
          }
      }
      
      // MARK: - UITableViewDataSource Methods
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return itemsToShow.count
      }
    
    
    // MARK: -

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
            let subItemsLabel = UILabel(frame: CGRect(x: 15, y: 40, width: cell.contentView.frame.width - 30, height: 1000))
            subItemsLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            subItemsLabel.textColor = UIColor.black
            subItemsLabel.numberOfLines = 0
            var text = ""
            for subItem in item.subItems {
                text += "\(subItem.name) - \(subItem.brand)\n\n"
            }
            subItemsLabel.text = text
            subItemsLabel.sizeToFit()
            cell.contentView.addSubview(subItemsLabel)
            
            // Adicionando botões de adicionar e remover
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
            
  
            cellHeights[indexPath.row] = subItemsLabel.frame.height + 60 //
        } else {
            cellHeights[indexPath.row] = 40
        }
        
        return cell
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
      // MARK: - UITableViewDelegate Methods
      
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
      
      // MARK: - Actions
      
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
