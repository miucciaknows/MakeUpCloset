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
    var color: String?
    var finish: String?
    var openingDate: Date?
    var expirationDate: Date?
}


struct Item {
    var name: String
    var brand: String
    var subItems: [SubItem]
}



extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
        case .right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        self.addSublayer(border)
    }
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
              let openingDateText = alertController.textFields?[2].text
              let expirationDateText = alertController.textFields?[3].text
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "YYYY/dd/MM"
              
              let openingDate = dateFormatter.date(from: openingDateText ?? "")
              let expirationDate = dateFormatter.date(from: expirationDateText ?? "")
              
              var color: String?
              var finish: String?
              
              if self.selectedButton == .make_Up {
                  color = alertController.textFields?[4].text
                  finish = alertController.textFields?[5].text
              }
              
              let newItem = SubItem(name: name, brand: brand,  color: color,
                                    finish: finish,
                                    openingDate: openingDate,
                                    expirationDate: expirationDate)
              
              self.itemsToShow[cellIndex].subItems.append(newItem)
              
              // Atualizar a altura da célula
              self.cellHeights[cellIndex] = UITableView.automaticDimension
              
              // Recarregar a célula
              self.tableContentView.reloadRows(at: [IndexPath(row: cellIndex, section: 0)], with: .none)
              
              self.saveSubItemsToUserDefaults()
          }
          alertController.addAction(addAction)
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          present(alertController, animated: true, completion: nil)
      }
      
      //MARK: -
      
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
