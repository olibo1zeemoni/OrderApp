//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
   var minutesToPrepareOrder = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)

        
        // self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuController.shared.order.menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)

       configure(cell, forItem: indexPath)
       
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItem indexPath: IndexPath){
        guard let cell = cell as? MenuItemCell else{ return }
         
         //let menuItem = menusItems[indexPath.row]
         
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
         cell.itemName = menuItem.name
         cell.itemPrice = menuItem.price
         cell.image = nil
         cell.tintColor = #colorLiteral(red: 0.4062065482, green: 0.3149974644, blue: 0.7378988862, alpha: 1)
       
        
         imageLoadTasks[indexPath] = Task{
            if let image = try? await MenuController.shared.fetchPhoto(from: menuItem.imageURL){
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath == indexPath{
                    cell.image = image
                    
                }
            }
        
             imageLoadTasks[indexPath] = nil
         }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imageLoadTasks.forEach { key,value in
            value.cancel()
        }
    }
    
    
    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        
      shouldPerformSegue(withIdentifier: "confirmOrder", sender: nil )
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }
    
    
    @IBAction func unwindToOrderTable(segue: UIStoryboardSegue){
        if segue.identifier == "dismissConfirmation"{
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { result, menuItems -> Double  in
            return result + menuItems.price
        }
        
        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
        
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.uploadOrder()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func uploadOrder(){
        let menuIDs = MenuController.shared.order.menuItems.map { $0.id }
        Task{
            do{
                let minutesToPrepare = try await MenuController.shared.submitOrders(forMenuIds: menuIDs)
                minutesToPrepareOrder = minutesToPrepare
                self.performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch{
                displayError(error, title: "Order Submission failed")
                
            }
        }
    }
    
    func displayError(_ error: Error, title: String){
        guard let _ = viewIfLoaded?.window else {return}
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            NSLog("The \(error) was triggered")
            
        }))
        self.present(alert, animated: true, completion: nil)
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)}
        
    }
            
     
    
     //Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
      

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                MenuController.shared.updateUserActivity(controller: .order)
            }

 

}
