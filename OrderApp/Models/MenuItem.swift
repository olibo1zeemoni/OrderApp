//
//  MenuItem.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import Foundation
import CoreVideo

struct MenuItem: Codable{
    var id: Int
    var name: String
    var price: Double
    var imageURL: URL
    var description: String
    var category: String
    
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case price
        case imageURL = "image_url"
        case description
        case category
    }
    
}
