//
//  Order.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import Foundation

struct Order:Codable{
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []){
        self.menuItems = menuItems
    }
}
