//
//  BillsForm.swift
//  CoHab
//
//  Created by Christian  on 4/10/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import Firebase

class BillsFormViewController: UIViewController {
    
    //set up firebase reference to query bills
    let ref = Firebase(url:"https://cohabapp.firebaseio.com/bills")
    
    
    var bills: [NSDictionary] = []
    
    var groupID: String!
    
    
    // These are the ourlets for user input for the bill
    @IBOutlet weak var billName: UITextField!
    @IBOutlet weak var billTotal: UITextField!
    @IBOutlet weak var billDueDate: UIDatePicker!
    let flag = true
    @IBAction func Cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // This sends us back to the bill view
    @IBAction func submitBill(sender: AnyObject) {
        let bName = billName.text
        let bTotal = billTotal.text
        
        //converting date to string to store in DB
        let billDateConverted = billDueDate.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateFormatter.stringFromDate(billDateConverted)
        let bDue = dateString
        
        //makes all items into type NSDictionary so it can be stored in database as NSString
        let user: NSDictionary = ["billName": bName!, "billTotal":bTotal!, "billDue":bDue, "bCompleted":false]
        
        //adds firebase child node
        let group = self.ref.childByAppendingPath(bName!)
        
        //write data to Firebase
        group.setValue(user)
        
    performSegueWithIdentifier("backToBills", sender: self)
    }

}
    
