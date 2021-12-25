//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Olibo moni on 25/12/2021.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var orderConfirmLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var minutesToPrepare: Int
    
    init?(coder: NSCoder, minutesToPrepare: Int){
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderConfirmLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes"
        
    }
    
    


}
