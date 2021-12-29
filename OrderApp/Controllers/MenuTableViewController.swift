//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menusItems: [MenuItem] = []
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    let category: String
    
    init?(coder: NSCoder, category:String){
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized

        Task{
            do{
                let menuItems = try await MenuController.shared.fetchMenuItems(forCategory: category)
                let menuitems = menuItems.filter({$0.category == category })
                updateUI(with: menuitems)
            } catch{
                displayError(error, title: "Failed to fetch MenuItems for \(category)")
            }
        }
        // self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imageLoadTasks.forEach { key,value in value.cancel()
        }
    }

    func updateUI(with menuItems: [MenuItem]){
        self.menusItems = menuItems
        tableView.reloadData()
    }
    
    func displayError(_ error: Error, title: String){
        guard let _ = viewIfLoaded?.window else {return}
        let alert = UIAlertController(title: title, message: String(describing: error), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            NSLog("The \(error) was triggered")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder, sender: Any?) -> DetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        let menuItem = menusItems[indexPath.row]
        
        return DetailViewController(coder: coder, menuItem: menuItem)
    }
    
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return menusItems.count
    }
    
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        configure(cell, forItemAt: indexPath)
        

        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath){
       guard let cell = cell as? MenuItemCell else{ return }
        
        let menuItem = menusItems[indexPath.row]
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(controller: .menu(category: category))
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
}
