//
//  MenuViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 15/10/23.
//

import Foundation
import UIKit

enum choosenButton {
    case skinCare
    case makeUp
    case hairCare
    case fragrances
}


class MenuViewController:UIViewController {
    
  
    
    var selectedButtonType: choosenButton?
    
    @IBOutlet weak var makeUpButton: UIButton!
    
    @IBOutlet weak var skincareButton: UIButton!
    
    
    @IBOutlet weak var hairCareButton: UIButton!
    
    @IBOutlet weak var fragrancesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLook(skincareButton)
        setUpLook(makeUpButton)
        setUpLook(hairCareButton)
        setUpLook(fragrancesButton)
    }
    
    private func setUpLook(_ button: UIButton) {
        button.layer.cornerRadius = 34;
        button.layer.borderColor = UIColor.lightGray.cgColor;
        button.layer.borderWidth = 0.5;
    }
    
    
    @IBAction func makeupSelected(_ sender: Any) {
        selectedButtonType = .makeUp
    }
    
    
    @IBAction func skincareSelected(_ sender: Any) {
        selectedButtonType = .skinCare
    }
    
    @IBAction func haircareSelected(_ sender: Any) {
        selectedButtonType = .hairCare
    }
    
  
    @IBAction func fragancesSelected(_ sender: Any) {
        selectedButtonType = .fragrances
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ClosetViewType" {
               if let destination = segue.destination as? ClosetViewController {
                   destination.selectedButton = selectedButtonType
               }
           }
       }
       
   }
