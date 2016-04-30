//
//  TaskFormViewController.swift
//  CoHab
//
//  Created by Christian  on 4/11/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import Firebase

class TaskFormViewController: UIViewController {
    
    //set up firebase reference to query bills
    let ref = Firebase(url:"https://cohabapp.firebaseio.com/tasks")
    
    var tasks: [NSDictionary] = []
    
    var groupID: String!
    

    @IBOutlet weak var taskNameInput: UITextField!
    @IBOutlet weak var taskDescriptionInput: UITextField!
    @IBOutlet weak var taskDueDateInput: UIDatePicker!
    
    @IBAction func submitTask(sender: AnyObject) {
        let tName = taskNameInput.text
        let tDescription = taskDescriptionInput.text
        
        let taskDateConverted = taskDueDateInput.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateFormatter.stringFromDate(taskDateConverted)
        let tDue = dateString
        
        //makes all items into type NSDictionary so it can be stored in database as NSString
        let user: NSDictionary = ["taskName": tName!, "taskDescription":tDescription!, "taskDue": tDue]
        
        let group = self.ref.childByAppendingPath(tName!)
        group.setValue(user)
          performSegueWithIdentifier("submitTask", sender: self)
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    // This is what is processed after you submit the bill
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "submitTask") {
//            let svc = segue.destinationViewController as! TaskViewController;
//            // This formats the date into a string
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            let taskDueDateString = dateFormatter.stringFromDate(taskDueDateInput.date)
//            // These are the variables we will transfer back to our table after the user submits them
//            svc.taskNameString = taskName.text
//            svc.taskDescriptionString = taskDescription.text
//            svc.taskDateString = taskDueDateString
//        }
//    }
    
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
