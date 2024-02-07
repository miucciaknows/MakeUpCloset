//
//  MenuViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 15/10/23.
//

import Foundation
import UIKit

enum ButtonType {
    case cuassado
    case make_Up
    case hair_Care
    case fragrances
    
}


class MenuViewController:UIViewController {
    
    
    var selectedButtonType: ButtonType?
    
    @IBOutlet weak var makeUpButton: UIButton!
    

    @IBOutlet weak var hairCareButton: UIButton!
    

    @IBOutlet weak var fragrancesButton: UIButton!
    

    @IBOutlet weak var careSkinButton: UIButton!
    
    
    @IBAction func careSkinButton(_ sender: UIButton) {
        selectedButtonType = .cuassado
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

 
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLook(makeUpButton)
        
        setUpLook(hairCareButton)
        
        setUpLook(fragrancesButton)
        


        
    }
    
    
    private func setUpLook(_ button: UIButton) {
        button.layer.cornerRadius = 34;
        button.layer.borderColor = UIColor.lightGray.cgColor;
        button.layer.borderWidth = 0.5;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ClosetOptionClass" {
               if let destination = segue.destination as? ClosetViewController {
                   destination.selectedButton = selectedButtonType
               }
           }
       }
       
   }
