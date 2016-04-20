//
//  TaskViewController.swift
//  CoHab
//
//  Created by Christian  on 4/11/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TaskViewController: UIViewController {

    // These three variables are being pulled from the form to add a new label
    var taskNameString:String!
    var taskDescriptionString:String!
    var taskDateString:String!
    

    override func viewDidLoad() {
        if (taskNameString != nil || taskDescriptionString != nil || taskDateString != nil){
            taskName.append(taskNameString)
            taskDescription.append(taskDescriptionString)
            dueDate.append(taskDateString)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTask(sender: AnyObject) {
        performSegueWithIdentifier("addTask", sender: self)
    }
    
    // These are the three arrays that display what is in the table
    var taskName = ["Dishes","Take out the trash"]
    var taskDescription = ["Can someone wash the dishes they're piling up","Someone needs to take out the trash"]
    var dueDate = ["10/05/2016","10/06/2016"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // This is how many rows are in the table, I just used the size of the "bills" array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskName.count
    }
    
    /*  gonna leave this here if need to reference it later on
    // This actually creates our table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.taskName.text = taskName[indexPath.row]
        cell.taskDescription.text = taskDescription[indexPath.row]
        cell.taskDate.text = dueDate[indexPath.row]
        return cell
    }
    */
    
    //Create table edited so theres a slide left/right function
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let reuseIdentifier = "programmaticCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel!.text = taskName[indexPath.row]
        cell.detailTextLabel!.text = taskDescription[indexPath.row] + " due by " + dueDate[indexPath.row]
        
        // cell.delegate = self //optional
        
        //configures left buttons :
        //I added the callback or in otherwords functionality for if you click a button on paid. right now the paid function deletes the cell.
        cell.leftButtons = [MGSwipeButton(title: "Paid", icon: UIImage(named:"check.png"), backgroundColor: UIColor.greenColor(),callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            cell.backgroundColor = UIColor.greenColor()
            return true
        })
            ,MGSwipeButton(title: "Will Pay", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.orangeColor(),callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("Convenience callback for swipe buttons!")
                cell.backgroundColor = UIColor.orangeColor()
                return true
            })]
        cell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        
        
        //configures right buttons:
        
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(),callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            self.taskName.removeAtIndex(indexPath.row)
            self.taskDescription.removeAtIndex(indexPath.row)
            self.dueDate.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            return true
        })
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        
        return cell
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
