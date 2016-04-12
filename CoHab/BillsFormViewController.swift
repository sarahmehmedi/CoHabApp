//
//  BillsForm.swift
//  CoHab
//
//  Created by Christian  on 4/10/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit


class BillsFormViewController: UIViewController {

    // These are the ourlets for user input for the bill
    @IBOutlet weak var billName: UITextField!
    @IBOutlet weak var billTotal: UITextField!
    @IBOutlet weak var billDueDate: UIDatePicker!
    
    // This sends us back to the bill view
    @IBAction func submitBill(sender: AnyObject) {
        performSegueWithIdentifier("submitBill", sender: self)
    }
    // This is what is processed after you submit the bill
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "submitBill") {
            let svc = segue.destinationViewController as! BillsViewController;
            // This formats the date into a string
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let billDueDateString = dateFormatter.stringFromDate(billDueDate.date)
            // These are the variables we will transfer back to our table after the user submits them
            svc.billNameString = billName.text
            svc.billTotalString = billTotal.text
            svc.billDateString = billDueDateString
        }
    }
}
    
