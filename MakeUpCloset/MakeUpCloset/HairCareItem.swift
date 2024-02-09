//
//  HairCareItem.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 09/02/24.
//

import Foundation

class HairCareItem: BeautyItem {
    var name: String
    var brand: String
    var subItems: [SubItem]
    var openingDate: Date? 
    var expiryDate: Date?

    init(name: String, brand: String, openingDate: Date? = nil, expiryDate: Date? = nil, subItems: [SubItem] = []) {
        self.name = name
        self.brand = brand
        self.openingDate = openingDate
        self.expiryDate = expiryDate
        self.subItems = subItems
    }
}
