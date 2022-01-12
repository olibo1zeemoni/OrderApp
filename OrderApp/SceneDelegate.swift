//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Olibo moni on 23/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var orderTabBarItem : UITabBarItem!
    var window: UIWindow?

  @objc func updateOrderBadge(){
      switch MenuController.shared.order.menuItems.count {
      case 0:
          orderTabBarItem.badgeValue = nil
      case let count:
          orderTabBarItem.badgeValue = String(count)
      }
        
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let restoredOrder = stateRestorationActivity.order {
            MenuController.shared.order = restoredOrder
        }
        guard
            let restorationController = StateRestorationController(userActivity: stateRestorationActivity),
            let tabBarController = window?.rootViewController as? UITabBarController, tabBarController.viewControllers?.count == 2,
            let categoryTableViewController = (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? CategoryTableViewController
                
        else {
            return
        }
        
        switch restorationController {
        case .categories:
            break
        case .menu(let category):
            let menuTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue, creator: { (coder) in
                return MenuTableViewController(coder: coder, category: category)
            })
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
        case .menuItemDetail(let menuItem):
            let menuTableViewController = storyboard.instantiateViewController(identifier: StateRestorationController.Identifier.menu.rawValue) { (coder) in
                return MenuTableViewController(coder: coder, category: menuItem.category)
            }
            let detailViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { (coder) in
                return DetailViewController(coder: coder, menuItem: menuItem)
            }
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: false)
            categoryTableViewController.navigationController?.pushViewController(detailViewController, animated: false)
            
        case .order:
            tabBarController.selectedIndex = 1
        }
            
    }
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

