//
//  ClosetViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 26/12/23.
//


import Foundation
import UIKit

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedButton: choosenButton?
    
    @IBOutlet weak var tableContentView: UITableView!

    @IBOutlet weak var pageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch selectedButton {
        case .skinCare:
            skinCareContent()
        case .makeUp:
            makeUpContent()
        case .hairCare:
            hairCareContent()
        case .fragrances:
            fragrancesContent()
        default:
            break
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    private func skinCareContent() {
        
    }
    
    
    private func makeUpContent() {
        
    }
    
    private func hairCareContent() {
        
    }
    
    private func fragrancesContent() {
        
    }
    
    
}

