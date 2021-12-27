//
//  MenuController.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import UIKit

class MenuController {
    static let shared = MenuController()
    var order = Order(){
        didSet{
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    let baseURL = URL(string: "http://localhost:8080/")!

    
    func fetchCategories() async throws -> [String] {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        let (data,response) = try await URLSession.shared.data(from: categoriesURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {throw MenuControllerErrors.categoriesNotFound}
        
        let jsonDecoder = JSONDecoder()
        let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
        
        
        return categoriesResponse.categories
    }

enum MenuControllerErrors:Error,LocalizedError {
    case categoriesNotFound
    case menuItemNotFound
    case orderRequestFailed
    case failedToLoadPhoto
}

    
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        let baseMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "catogory", value: categoryName)]
        let menuURL = components.url!
        let (data,response) = try await URLSession.shared.data(from: menuURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {throw MenuControllerErrors.menuItemNotFound}
        let jsonDecoder = JSONDecoder()
        let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
        //let menuResponseItems = menuResponse
        
        //menuResponseItems.filter({ })
        
        return menuResponse.items
    }

    
typealias MinutesToPrepare = Int
    
    func submitOrders(forMenuIds menuIds: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let menuIdsDict = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        request.httpBody = jsonData
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw MenuControllerErrors.orderRequestFailed}
        
        let jsonDecoder = JSONDecoder()
        let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
    
    
    func fetchPhoto(from url: URL) async throws -> UIImage{
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else{throw MenuControllerErrors.failedToLoadPhoto }
        
        guard let image = UIImage(data: data) else {
            throw MenuControllerErrors.failedToLoadPhoto
        }
                return image
    }


}
