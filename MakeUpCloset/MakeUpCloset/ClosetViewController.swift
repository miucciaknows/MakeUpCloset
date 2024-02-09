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
              // Adicionando botão "+" à célula expandida
              let addButton = UIButton(type: .system)
              addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
              addButton.tintColor = .systemPink
              addButton.addTarget(self, action: #selector(addSubitem(_:)), for: .touchUpInside)
              addButton.frame = CGRect(x: 10, y: 70, width: 30, height: 30)
              cell.accessoryView = addButton
          } else {
              cell.textLabel?.numberOfLines = 1
              cell.textLabel?.text = item.name
              cellHeights[indexPath.row] = UITableView.automaticDimension
              cell.accessoryView = nil
          }
          
          return cell
      }
      
      @objc func addSubitem(_ sender: UIButton) {
          guard let tappedCell = sender.superview as? UITableViewCell,
                let indexPath = tableContentView.indexPath(for: tappedCell) else {
              return
          }
          // Adicionando um novo subitem à célula selecionada
          let newItem = SubItem(name: "New Item", brand: "New brand")
          itemsToShow[indexPath.row].subItems.append(newItem)
          
          tableContentView.reloadData()
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
