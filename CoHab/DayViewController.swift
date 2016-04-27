//
//  DayViewController.swift
//  CoHab
//
//  Created by Dominique Allen on 4/22/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell

class DayViewController: UIViewController, /*UITableViewDataSource,*/ UITableViewDelegate {
    
    let ref = Firebase(url: "https://cohabapp.firebaseio.com/events")
    var items = [NSDictionary]()
    
    // These three variables are being pulled from the form to add a new label
    var eventTitleString:String!
    var eventDescString:String!
    var eventStartString:String!
    var eventEndString:String!
    var eventLocationString:String!
    var eventCreatorString:String!
    
    // This is our table for events
    @IBOutlet weak var table: UITableView!
    
    func loadDataFromFirebase(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        ref.observeEventType(.Value, withBlock: {snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children{
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.items = tempItems
            print(tempItems)
            self.table.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        self.table.reloadData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        items = [NSDictionary]()
        
        loadDataFromFirebase()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // This is how many rows are in the table, I just used the size of the "events" array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    var eventTitle = ["Happy 4/20", "Feminist Theology", "Software Engineering"]
    var eventDesc = ["daily activites/festivities", "Analyzing Adam & Eve", "developing CoHab"]
    var eventStart = ["04/20/16 04:20", "04/20/16 04:45", "04/20/16 05:15"]
    var eventEnd = ["04/20/16 04:30", "04/20/16 05:00", "04/20/16 05:30"]
    var eventLocation = ["6327 N Broadway", "Loyola University Chicago", "LUC Water Tower"]
    var eventCreator = ["nieky.allen", "sarah.mehmedi", "christian.lanzer"]
    
    //Create table edited so theres a slide right function
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let reuseIdentifier = "programmaticCell"
        //let dict = items[indexPath.row]
        var cell = self.table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        configureCell(cell, indexPath: indexPath)
        
        //configures right buttons:
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(),callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            
            if self.items.count >= 1 {
                tableView.beginUpdates()
                let dict = self.items[indexPath.row]
                let name = dict["eventTitle"] as! String
                
                let profile = self.ref.childByAppendingPath(name)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.items.removeAtIndex(indexPath.row)
                profile.removeValue()
                
                if self.items.count == 0 {
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
    
    
    func configureCell(cell: MGSwipeTableCell, indexPath: NSIndexPath){
        let dict = items[indexPath.row]
        
        let eTitle = dict["eventTitle"] as? String
        let eDesc = dict["eventDesc"] as? String
        let eStart = dict["eventStart"] as? String
        let eEnd = dict["eventEnd"] as? String
        let eLocation = dict["eventLocation"] as? String
        let eCreator = dict["eventCreator"] as? String
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = eTitle! + " by " + eCreator!
        cell.detailTextLabel!.text = "Location: " + eLocation! + "\nDescription: " + eDesc! + "\nFrom " + eStart! + " to " + eEnd!

        
    }
}