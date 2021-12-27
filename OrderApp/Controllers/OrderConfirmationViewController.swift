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
       
        
        //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        
        
       // progressBar.setProgress(<#T##progress: Float##Float#>, animated: true)

        orderConfirmLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes"
        
    }
    
   
//    let formatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.allowedUnits = [.minute]
//        return formatter
//    }()
    //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    
//    @objc func fireTimer() {
//        var minutesToUpdate = minutesToPrepare
//        print("Timer fired!")
//        minutesToUpdate -= 1
//
//        if minutesToPrepare == 0 {
//            timer.invalidate()
//        }
//    }
//
//    func returnMinutesRemaining()->Int {
//        let remaining: TimeInterval = Double(minutesToPrepare * 60) // e.g. 90 minutes represented in seconds
//
//         let result = formatter.string(from: remaining) ?? "0"
//
//        return Int(result) ?? 0
//    }
    var runCount = 0
    
    func callTimer()  { Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
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
