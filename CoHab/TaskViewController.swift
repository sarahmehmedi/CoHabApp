//
//  TaskViewController.swift
//  CoHab
//
//  Created by Christian  on 4/11/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import MGSwipeTableCell
import BTNavigationDropdownMenu
import Firebase

class TaskViewController: UIViewController {

    
    let ref = Firebase(url:"https://cohabapp.firebaseio.com/tasks")
    var tasks = [NSDictionary]()

    // These three variables are being pulled from the form to add a new label
    var taskNameString:String!
    var taskDescriptionString:String!
    var taskDateString:String!
    var menuView: BTNavigationDropdownMenu!

    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true);
        if (taskNameString != nil || taskDescriptionString != nil || taskDateString != nil){
            taskName.append(taskNameString)
            taskDescription.append(taskDescriptionString)
            dueDate.append(taskDateString)
            self.table.reloadData()
        }
        super.viewDidLoad()
        let items = ["Home", "Tasks", "Calendar", "Bills", "Chat", "Settings"]
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[0], items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if (indexPath == 0){
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("HomeVC")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            if (indexPath == 1){
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("taskView")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            if (indexPath == 2){
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("calenderView")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            if (indexPath == 3){
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("billsView")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            if (indexPath == 4)
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
                vc.selectedIndex = 0
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
            if (indexPath == 5){
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("settingsView")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
        }
        self.navigationItem.titleView = menuView
        // Do any additional setup after loading the view.
        
    }
    
 
    func loadDataFromFirebase(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ref.observeEventType(.Value, withBlock: {snapshot in
            var tempTasks = [NSDictionary]()
            
            for task in snapshot.children{
                let child = task as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempTasks.append(dict)
            }
            
            self.tasks = tempTasks
            self.table.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        self.table.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        tasks = [NSDictionary]()
        
        loadDataFromFirebase()
        
    }
    @IBOutlet weak var table: UITableView!

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
        return tasks.count
    }
    
    
    //Create table edited so theres a slide left/right function
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let reuseIdentifier = "programmaticCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }

        configureCell(cell, indexPath: indexPath)
        
        
        //configures left buttons :
        
        //I added the callback or in otherwords functionality for if you click a button on paid. right now the paid function deletes the cell.
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: UIColor.greenColor(),callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            cell.backgroundColor = UIColor.greenColor()
            return true
        })
            ,MGSwipeButton(title: "In Progress", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.orangeColor(),callback: {
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
            
            if self.tasks.count >= 1 {
                tableView.beginUpdates()
                let dict = self.tasks[indexPath.row]
                let name = dict["taskName"] as! String
                
                let profile = self.ref.childByAppendingPath(name)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tasks.removeAtIndex(indexPath.row)
                profile.removeValue()
                
                if self.tasks.count == 0{
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                tableView.endUpdates()
            }

            return true
        })
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        
        return cell
    }
    
    func configureCell(cell:MGSwipeTableCell, indexPath: NSIndexPath){
        let dict = tasks[indexPath.row]
        
        let tName = dict["taskName"] as? String
        let tDescription = dict["taskDescription"] as? String
        let tDue = dict["taskDue"] as? String
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = tName! + " Finish by: " + tDue!
        cell.detailTextLabel!.text = tDescription
    }

}
