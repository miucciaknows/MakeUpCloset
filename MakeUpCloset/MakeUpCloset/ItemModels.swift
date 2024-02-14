//
//  ItemModels.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 11/02/24.
//

import Foundation

// MARK: - Model

struct SubItem: Codable {
    var name: String
    var brand: String
    var color: String?
    var finish: String?
    var openingDate: Date?
    var expirationDate: Date?
}

struct Item {
    var name: String
    var brand: String
    var subItems: [SubItem]
}
