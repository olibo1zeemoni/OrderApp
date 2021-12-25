//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import UIKit

@MainActor
class CategoryTableViewController: UITableViewController {
    static let sharer = CategoryTableViewController()
    var categories: [String] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        Task{
            do{
                let categories = try await MenuController.shared.fetchCategories()
                updateUI(with: categories)
                
            } catch{
                displayError(error, title: "Failed to fetch categories")
                
            }
        }
       
        // self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func updateUI(with categories: [String]){
        self.categories = categories
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
    
    
    
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        let category = categories[indexPath.row]
        

        
        
        return MenuTableViewController(coder: coder, category: category)
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath){
        let category = categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.uppercased()
        content.textProperties.color = #colorLiteral(red: 0.4079208076, green: 0.3443185091, blue: 1, alpha: 1)
        cell.contentConfiguration = content
      
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
   

  

   
}
