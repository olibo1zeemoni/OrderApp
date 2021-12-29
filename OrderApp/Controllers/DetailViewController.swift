//
//  DetailViewController.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var menuPhoto: UIImageView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuPrice: UILabel!
    @IBOutlet weak var menuCategory: UILabel!
    @IBOutlet weak var menuDescription: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    let menuItem : MenuItem
    
    
    init?(coder: NSCoder, menuItem: MenuItem){
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//let someURl = URL(string: "https://1673-197-159-139-219.ngrok.io/images/4.png")!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        Task {
            do{
                let photo = try await MenuController.shared.fetchPhoto(from: menuItem.imageURL)
                   menuPhoto.image = photo
                
            } catch{ //MenuController.MenuControllerErrors.failedToLoadPhoto
                
            }
        }
        
       
       
    }
    
    func updateUI(){
        id.text = "\(menuItem.id)"
        menuName.text = menuItem.name
        menuPrice.text = menuItem.price.formatted(.currency(code: "usd"))
        menuCategory.text = menuItem.category
        menuDescription.text = menuItem.description
        
    }
   
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.02, options: [], animations: {
            self.menuPhoto.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)},
         completion: nil)
        
        //{ _ in self.menuPhoto.transform = CGAffineTransform.identity}


        MenuController.shared.order.menuItems.append(menuItem)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(controller: .menuItemDetail(menuItem))
    }
    

}
