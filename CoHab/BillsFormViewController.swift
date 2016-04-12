//
//  BillsForm.swift
//  CoHab
//
//  Created by Christian  on 4/10/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import SwiftForms


class BillsFormViewController: UIViewController {

    @IBOutlet weak var billName: UITextField!
    @IBOutlet weak var billTotal: UITextField!
    @IBOutlet weak var billDueDate: UIDatePicker!
    @IBAction func submitBill(sender: AnyObject) {
        performSegueWithIdentifier("submitBill", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "submitBill") {
            let svc = segue.destinationViewController as! BillsViewController;
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let billDueDateString = dateFormatter.stringFromDate(billDueDate.date)
            svc.billNameString = billName.text
            svc.billTotalString = billTotal.text
            svc.billDateString = billDueDateString
        }
    }
}
    
