//
//  MakeUpItem.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 09/02/24.
//

import Foundation

class MakeUpItem: BeautyItem {
    var name: String
    var brand: String
    var subItems: [SubItem]

    init(name: String, brand: String, subItems: [SubItem] = []) {
        self.name = name
        self.brand = brand
        self.subItems = subItems
    }
}
