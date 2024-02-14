//
//  MenuViewController.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 15/10/23.
//

import Foundation
import UIKit

enum ButtonType {
    case skin_care
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
        selectedButtonType = .skin_care
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
        setUpLook(careSkinButton)
        setUpLook(hairCareButton)
        setUpLook(fragrancesButton)
        

    }
    
    private func setUpLook(_ button: UIButton) {
        let bottomLinePath = UIBezierPath()
        bottomLinePath.move(to: CGPoint(x: 0, y: button.bounds.height))
        bottomLinePath.addLine(to: CGPoint(x: button.bounds.width, y: button.bounds.height))
        
        let bottomLineLayer = CAShapeLayer()
        bottomLineLayer.path = bottomLinePath.cgPath
        bottomLineLayer.strokeColor = UIColor.lightGray.cgColor
        bottomLineLayer.lineWidth = 0.5
        bottomLineLayer.lineDashPattern = [4, 4]
        
        button.layer.addSublayer(bottomLineLayer)
        
        button.layer.cornerRadius = 34
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ClosetOptionClass" {
               if let destination = segue.destination as?  ClosetViewController {
                   destination.selectedButton = selectedButtonType
               }
           }
       }
       
   }
