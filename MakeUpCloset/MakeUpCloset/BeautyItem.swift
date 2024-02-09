//
//  BeautyItem.swift
//  MakeUpCloset
//
//  Created by Nathalia Trazzi on 09/02/24.
//

protocol BeautyItem {
    var name: String { get }
    var brand: String { get }
    var subItems: [SubItem] { get set }
}

enum BeautyItemType {
    case make_Up
    case skin_care
    case hair_Care
    case fragrances
}
