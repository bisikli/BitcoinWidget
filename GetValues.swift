//
//  GetValues.swift
//  BitcoinWidget
//
//  Created by Anıl T. on 28.11.2017.
//  Copyright © 2017 Anıl T. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications
import AudioToolbox
import UIKit

struct Ticker:Codable {
    var buy:  Double
    var sell: Double
    var high: Double
    var low:  Double
    init() {
        buy  = 0.0
        sell = 0.0
        high = 0.0
        low  = 0.0
    }
    init( mbuy: Double, msell: Double, mhigh: Double, mlow:  Double) {
        buy  = mbuy
        sell = mbuy
        high = mhigh
        low  = mlow
    }
}

typealias CompletionHandler = () -> Void

class GetValues: NSObject {
    var values = Ticker(mbuy: 0.0, msell: 0.0, mhigh: 0.0, mlow: 0.0)
    var lastDate: String!
    var totalBitcoinValue: Double!

   static let sharedInstance = GetValues()
    
    override init() {
        super.init()
    }
    
    func getValues() -> Ticker {
        if let existingValues = UserDefaults.standard.value(forKey: "Ticker") {
            return existingValues as! Ticker
        } else {
            return values
        }
    }
    func getTotalBitcoin() -> Double {
        let userDefaults = UserDefaults(suiteName: "group.com.bitcoinwidget")
        if let existingTotalBitcoin = userDefaults?.object(forKey: "totalBitcoinValue") as? Double {
            print("Existing Bitcoin: \(existingTotalBitcoin)")
             return existingTotalBitcoin
        } else {
            return 0.08055213
        }
    }
    
    func setTotalBitcoin(bitcoin: Double){
        totalBitcoinValue = bitcoin
        let x = UserDefaults(suiteName: "group.com.bitcoinwidget")
        x?.set(bitcoin, forKey: "totalBitcoinValue")
        x?.synchronize()
    }
    
    func getLastDate()->String{
        if let existingLastDate = UserDefaults.standard.value(forKey: "lastDate") {
            return existingLastDate as! String
        } else {
            return "0"
        }
    }
    func setLastDate(date: String){
        lastDate = date
        UserDefaults.standard.set(lastDate, forKey: "lastDate")
    }
    
    func downloadBitcoinValeus(completion: @escaping CompletionHandler){
        
        let url = URL(string: "https://koinim.com/ticker")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if var json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    self.values = Ticker(mbuy:json["buy"] as! Double, msell: json["sell"] as! Double, mhigh: json["high"] as! Double, mlow: json["low"] as! Double)
                    
                    UserDefaults.standard.set(json, forKey: "jsonValues")
                    
                    self.createNotification()
                    completion()
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    func createNotification(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        var dateString = ""
        
        dateString = dateFormatter.string(from:Date())
        print(dateString)
        
        if let x = Int64(dateString) {
            if let y = Int64(getLastDate()){
                if (x-y>5){
                    setLastDate(date: dateString)
                    
                    let str = String(format: "%.2f",self.values.sell * getTotalBitcoin())
                    let notification = UNMutableNotificationContent()
                    notification.title = "Bitcoin"
                    notification.body = "Buy: \(self.values.buy) Sell: \(self.values.sell) Total: \(str)"
                    notification.badge = 1
                    notification.sound = UNNotificationSound.default()
                    
                    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
    }
}
