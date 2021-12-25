//
//  MenuItemCell.swift
//  OrderApp
//
//  Created by Olibo moni on 25/12/2021.
//

import UIKit

class MenuItemCell: UITableViewCell{
    
    var itemName: String? = nil {
        didSet{
            if oldValue != itemName {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var itemPrice: Double? = nil {
        didSet{
            if oldValue != itemPrice {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var image: UIImage? = nil {
        didSet{
            if oldValue != image {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)
        content.text = itemName
        content.secondaryText = itemPrice?.formatted(.currency(code: "usd"))
        content.prefersSideBySideTextAndSecondaryText = true
        if let image = image {
            content.image = image
        } else {
            content.image = UIImage(systemName: "photo.on.rectangle")
        }
        self.contentConfiguration = content
        
    }
    
    
}
