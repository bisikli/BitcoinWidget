//
//  TodayViewController.swift
//  widget
//
//  Created by Anıl T. on 21.11.2017.
//  Copyright © 2017 Anıl T. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications

class TodayViewController: UIViewController, NCWidgetProviding {
    var i = 0
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var marketValueLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var marketValue: UILabel!
    @IBOutlet weak var totalBitcoin: UILabel!
    @IBOutlet weak var profit2Tl: UILabel!
    
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var sellLabel: UILabel!
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        spinner.isHidden = false
        let totalBitcoinX = GetValues.sharedInstance.getTotalBitcoin()
        let valuesX = GetValues.sharedInstance.getValues()
        self.buyLabel.text = "\(valuesX.buy)"
        self.sellLabel.text = "\(valuesX.sell)"
        self.marketValue.text = String(format: "%.2f",valuesX.sell * totalBitcoinX)
        self.profit2Tl.text = String(format: "%.2f", (valuesX.sell * totalBitcoinX) - 2500)
        GetValues.sharedInstance.downloadBitcoinValeus {
            let totalBitcoin = GetValues.sharedInstance.getTotalBitcoin()
            let values = GetValues.sharedInstance.getValues()
            self.spinner.isHidden = true
            
            self.buyLabel.text = "\(values.buy)"
            self.sellLabel.text = "\(values.sell)"
            self.marketValue.text = String(format: "%.2f",values.sell * totalBitcoin)
            self.profit2Tl.text = String(format: "%.2f", (values.sell * totalBitcoin) - 2500)
        }
    }
    
    

    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
            GetValues.sharedInstance.downloadBitcoinValeus {
                let totalBitcoin = GetValues.sharedInstance.getTotalBitcoin()
                let values = GetValues.sharedInstance.getValues()
                self.spinner.isHidden = true
                self.buyLabel.text = "\(values.buy)"
                self.sellLabel.text = "\(values.sell)"
                self.marketValue.text = String(format: "%.2f",values.sell * totalBitcoin)
                self.profit2Tl.text = String(format: "%.2f", (values.sell * totalBitcoin) - 2500)
            }
            

        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
            self.bitcoinLabel.isHidden = true
            self.totalBitcoin.isHidden = true
            
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 161)
            self.bitcoinLabel.isHidden = false
            self.totalBitcoin.isHidden = false
           
            
           
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        spinner.isHidden = false
        var totalBitcoin = GetValues.sharedInstance.getTotalBitcoin()
        var values = Ticker()
        

       
        
        if let existingUserMail = UserDefaults.standard.value(forKey: "jsonValues") {
            let obj = existingUserMail as! [String:Any]
            print("objeleer: ")
            print(obj["buy"] ?? "")
            values.buy = obj["sell"] as! Double
            values.sell = obj["buy"] as! Double
        }
        
//        if let existingDate = UserDefaults.standard.value(forKey: "lastDate") {
//            lastDate = existingDate as! String
//        } else {
//            lastDate = "0"
//        }
        self.buyLabel.text = "\(values.buy)"
        self.sellLabel.text = "\(values.sell)"
        self.marketValue.text = String(format: "%.2f", values.sell * totalBitcoin )
        self.profit2Tl.text = String(format: "%.2f", (values.sell * totalBitcoin) - 2500)
        self.totalBitcoin.text = "\(totalBitcoin)"

        GetValues.sharedInstance.downloadBitcoinValeus {
            let values = GetValues.sharedInstance.getValues()
            self.spinner.isHidden = true
            self.buyLabel.text = "\(values.buy)"
            self.sellLabel.text = "\(values.sell)"
            self.marketValue.text = String(format: "%.2f",values.sell * totalBitcoin)
            self.profit2Tl.text = String(format: "%.2f", (values.sell * totalBitcoin) - 2500)
        }
        
        
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//        let generator = UIImpactFeedbackGenerator(style: .heavy)
//        generator.impactOccurred()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

     
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        GetValues.sharedInstance.downloadBitcoinValeus {
            let totalBitcoin = GetValues.sharedInstance.getTotalBitcoin()
            let values = GetValues.sharedInstance.getValues()
            self.spinner.isHidden = true

            self.buyLabel.text = "\(values.buy)"
            self.sellLabel.text = "\(values.sell)"
            self.marketValue.text = String(format: "%.2f",values.sell * totalBitcoin)
            self.profit2Tl.text = String(format: "%.2f", (values.sell * totalBitcoin) - 2500)
        }
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    

    
}
