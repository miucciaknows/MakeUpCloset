//
//  MenuViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 15/10/23.
//

import Foundation
import UIKit

enum choosenButton {
    case make_Up
    case skin_Care
    case hair_Care
    case fragrances
}


class MenuViewController:UIViewController {
    
  
    
    var selectedButtonType: choosenButton?
    
    @IBOutlet weak var makeUpButton: UIButton!
    
    @IBOutlet weak var skinCareButton: UIButton!
    

    
    @IBOutlet weak var hairCareButton: UIButton!
    
    

    @IBOutlet weak var fragrancesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLook(makeUpButton)
        
        setUpLook(skinCareButton)
        
        setUpLook(hairCareButton)
        
        setUpLook(fragrancesButton)
    }
    
    private func setUpLook(_ button: UIButton) {
        button.layer.cornerRadius = 34;
        button.layer.borderColor = UIColor.lightGray.cgColor;
        button.layer.borderWidth = 0.5;
    }
    
    
    
    @IBAction func makeUpButton(_ sender: UIButton) {
        selectedButtonType = .make_Up
    }
    

    
   
    @IBAction func hairCareButton(_ sender: UIButton) {
        selectedButtonType = .hair_Care
    }
    
    @IBAction func fragrancesButton(_ sender: UIButton) {
        selectedButtonType = .fragrances
    }
    
    @IBAction func skinCareButton(_ sender: UIButton) {
        selectedButtonType = .skin_Care
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ClosetViewType" {
               if let destination = segue.destination as? ClosetViewController {
                   destination.selectedButton = selectedButtonType
               }
           }
       }
       
   }
