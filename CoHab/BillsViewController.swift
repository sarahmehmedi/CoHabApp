//
//  BillsViewController.swift
//  
//
//  Created by Sarah Mehmedi on 4/3/16.
//
//

import UIKit
import MGSwipeTableCell
import SwiftForms


class BillsViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var billNameString:String!
    var billTotalString:String!
    var billDateString:String!
   override func viewDidLoad() {
    super.viewDidLoad()
    if (billNameString != nil || billTotalString != nil || billDateString != nil){
        bills.append(billNameString)
        total.append(billTotalString)
        dueDate.append(billDateString)
    }
    }
    
    @IBAction func addBill(sender: AnyObject) {
        performSegueWithIdentifier("addBill", sender: self)
    }
    @IBOutlet weak var table: UITableView!
    
    var bills = ["Rent","Water"]
    var total = ["400","50"]
    var dueDate = ["10/05/2016","10/06/2016"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.billName.text = bills[indexPath.row]
        cell.billTotal.text = total[indexPath.row]
        cell.billDueDate.text = dueDate[indexPath.row]
        return cell
    }
    

    
   
    /*func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "programmaticCell"
        var cell = self.table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = "Title"
        cell.detailTextLabel!.text = "Detail text"
        // cell.delegate = self //optional
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: UIColor.greenColor())
            ,MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.blueColor())]
        cell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor())
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        return cell
    }*/
}

