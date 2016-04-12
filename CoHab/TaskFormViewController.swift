//
//  TaskFormViewController.swift
//  CoHab
//
//  Created by Christian  on 4/11/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class TaskFormViewController: UIViewController {

    @IBOutlet weak var taskNameInput: UITextField!
    @IBOutlet weak var taskDescriptionInput: UITextField!
    @IBOutlet weak var taskDueDateInput: UIDatePicker!
    
    @IBAction func submitTask(sender: AnyObject) {
          performSegueWithIdentifier("submitTask", sender: self)
    }
    
    // This is what is processed after you submit the bill
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "submitTask") {
            let svc = segue.destinationViewController as! TaskViewController;
            // This formats the date into a string
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let taskDueDateString = dateFormatter.stringFromDate(taskDueDateInput.date)
            // These are the variables we will transfer back to our table after the user submits them
            svc.taskNameString = taskNameInput.text
            svc.taskDescriptionString = taskDescriptionInput.text
            svc.taskDateString = taskDueDateString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
