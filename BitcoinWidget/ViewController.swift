//
//  ViewController.swift
//  BitcoinWidget
//
//  Created by Anıl T. on 21.11.2017.
//  Copyright © 2017 Anıl T. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    @IBOutlet var currentPrice: UILabel!
    @IBOutlet var tradePRice: UITextField!
    @IBOutlet var quantity: UITextField!
    

    
    @IBAction func tradingButtonPressed(_ sender: UIButton) {
        if let cost = Double(quantity.text!) {
            
             GetValues.sharedInstance.setTotalBitcoin(bitcoin: cost)
            currentPrice.text = "\(cost)"
            print("The user entered a value price of \(cost)")
        } else {
            print("Not a valid number: \(quantity.text!)")
        }

        
    }
    
    override func viewDidLoad() {
        let x = GetValues.sharedInstance.getTotalBitcoin()
        currentPrice.text = "\(x)"
    }
    
    
}

