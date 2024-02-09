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
    var color: String // Adicionando propriedade de cor
    var openingDate: Date? // Adicionando propriedade de data de abertura
    var expiryDate: Date? // Adicionando propriedade de data de vencimento
    var subItems: [SubItem]

    init(name: String, brand: String, color: String, openingDate: Date? = nil, expiryDate: Date? = nil, subItems: [SubItem] = []) {
        self.name = name
        self.brand = brand
        self.color = color
        self.openingDate = openingDate
        self.expiryDate = expiryDate
        self.subItems = subItems
    }
}
