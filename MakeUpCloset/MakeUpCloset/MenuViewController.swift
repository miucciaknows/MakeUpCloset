//
//  MenuViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 15/10/23.
//

import Foundation
import UIKit

class MenuViewController:UIViewController {
    
    @IBOutlet weak var skincareButton: UIButton!
    @IBOutlet weak var makeUpButton: UIButton!
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
    
}
