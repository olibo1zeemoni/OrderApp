//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Olibo moni on 25/12/2021.
//

import UIKit
import Foundation

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var orderConfirmLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarLabel: UILabel!
    
    var minutesToPrepare: Int
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    init?(coder: NSCoder, minutesToPrepare: Int){
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var currentTime = Date().formatted(date: .omitted, time: .shortened)
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progressViewStyle = .default
        progressBarLabel.text = String(minutesToPrepare)
        progressBar.progress = 0.0
        callTimer()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { permissionGranted, error in
            if (!permissionGranted) {
                print("Permission Denied")
            }
        }
        
        
        //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createAlertTapped(_:)), userInfo: nil, repeats: true)
        
        
        orderConfirmLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes"
        
    }
    
    
    @IBAction func createAlertTapped(_ sender: UIButton) {
        notificationCenter.getNotificationSettings { [self] (settings) in
            
            DispatchQueue.main.async {
                if(settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = "Order App"
                    content.body = "Order will be ready in 10 minutes"
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    
                    
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request){(error) in
                        if(error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                    
                    let alertDialog = UIAlertController(title: "Order App", message: "Your Order will be ready in 10 minutes", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                    self.present(alertDialog, animated: true)
                } else  {
                    
                    let alertDialog  = UIAlertController(title: "Enable Notifications? ", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        else{ return}
                        
                        if(UIApplication.shared.canOpenURL(settingsURL)){
                            UIApplication.shared.open(settingsURL, options: [:]) { _ in
                                
                            }
                        }
                        
                    }
                    
                    alertDialog.addAction(goToSettings)
                    alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                    self.present(alertDialog, animated: true)
                    
                }
            }
            
            
        }
        
    }
    
    var runCount = 0
    
    func callTimer()  { Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        let progress = Float(1.0 / Double(self.minutesToPrepare))
        print("Timer fired!")
        self.progressBarLabel.text = String(self.minutesToPrepare - self.runCount - 1)
        self.progressBar.progress += progress
        self.runCount += 1
        
        if self.runCount == self.minutesToPrepare {
            timer.invalidate()
        }
        
    }
    }
    
    
    
}
