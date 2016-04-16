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
    let flag = true
    @IBAction func Cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // This sends us back to the bill view
    @IBAction func submitBill(sender: AnyObject) {
    performSegueWithIdentifier("backToBills", sender: self)
    }

}
    
