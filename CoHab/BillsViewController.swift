//
//  BillsViewController.swift
//  
//
//  Created by Sarah Mehmedi on 4/3/16.
//
//

import UIKit
import MGSwipeTableCell


class BillsViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // These three variables are being pulled from the form to add a new label
    var billNameString:String!
    var billTotalString:String!
    var billDateString:String!
   
    @IBAction func backToBillsTable(segue:UIStoryboardSegue) {
        if (segue.identifier == "backToBills") {
            let svc = segue.sourceViewController as! BillsFormViewController;
            // This formats the date into a string
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let billDueDateString = dateFormatter.stringFromDate(svc.billDueDate.date)
            // These are the variables we will transfer back to our table after the user submits them
            billNameString = svc.billName.text
            billTotalString = svc.billTotal.text
            billDateString = billDueDateString
            if (billNameString != nil || billTotalString != nil || billDateString != nil){
                bills.append(billNameString)
                total.append(billTotalString)
                dueDate.append(billDateString)
                 self.table.reloadData()
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    // When the view is opened particularly if it is after submit it will add the new bills if there are new bill
    override func viewDidLoad() {
    super.viewDidLoad()
        print(bills)
    }
    
    // This is just the "+" button that takes us to the form to add a new bill
    @IBAction func addBill(sender: AnyObject) {
        performSegueWithIdentifier("addBill", sender: self)
    }
    
    // This is our table for bills
    @IBOutlet weak var table: UITableView!
    
    // These are the three arrays that display what is in the table
    var bills = ["Rent","Water"]
    var total = ["400","50"]
    var dueDate = ["10/05/2016","10/06/2016"]
    

    
    // This does nothing
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // This is how many rows are in the table, I just used the size of the "bills" array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
   //Create table edited so theres a slide left/right function - will have to connect the slide functions to something later
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "programmaticCell"
        var cell = self.table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = bills[indexPath.row]
        cell.detailTextLabel!.text = total[indexPath.row] + " dollars owed by " + dueDate[indexPath.row]
      
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
            self.bills.removeAtIndex(indexPath.row)
            self.total.removeAtIndex(indexPath.row)
            self.dueDate.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            return true
        })
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        
        return cell
    }
}

