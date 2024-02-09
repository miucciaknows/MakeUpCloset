//
//  BeautyItem.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 09/02/24.
//

import Foundation

protocol BeautyItem {
    var name: String { get }
    var brand: String { get }
    var subItems: [SubItem] { get set }
    var openingDate: Date? { get set }
    var expiryDate: Date? { get set }
}
