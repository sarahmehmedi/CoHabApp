//
//  BillsViewController.swift
//  
//
//  Created by Sarah Mehmedi on 4/3/16.
//
//

import UIKit
import MGSwipeTableCell
import BTNavigationDropdownMenu
import Firebase


class BillsViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let ref = Firebase(url:"https://cohabapp.firebaseio.com/bills")
    var items = [NSDictionary]()
    
    // These three variables are being pulled from the form to add a new label
    var billNameString:String!
    var billTotalString:String!
    var billDateString:String!
    var menuView: BTNavigationDropdownMenu!
   
    //looking at this, can the items in BillsFormViewcontroller be transferred here....?
    @IBAction func backToBillsTable(segue:UIStoryboardSegue) {
        if (segue.identifier == "backToBills") {
            let svc = segue.sourceViewController as! BillsFormViewController;
            // This formats the date into a string
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let billDueDateString = dateFormatter.stringFromDate(svc.billDueDate.date)
            // These are the variables we will transfer back to our table after the user submits them
            billNameString = svc.billName.text
            billTotalString = svc.billTotal.text
            billDateString = billDueDateString
            if (billNameString != nil || billTotalString != nil || billDateString != nil){
                billName.append(billNameString)
                billTotal.append(billTotalString)
                billDue.append(billDateString)
           //     loadDataFromFirebase()
                 self.table.reloadData()
            }
        }
    }
    
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
    // When the view is opened particularly if it is after submit it will add the new bills if there are new bill
    override func viewDidLoad() {
    super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        let items = ["Home", "Tasks", "Calendar", "Bills", "Chat"]
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[3], items: items)
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
            if(indexPath == 4)
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
                vc.selectedIndex = 0
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        self.navigationItem.titleView = menuView
        // Do any additional setup after loading the view.
    }
    
    // This is just the "+" button that takes us to the form to add a new bill
    @IBAction func addBill(sender: AnyObject) {
        performSegueWithIdentifier("addBill", sender: self)
    }
    
    // This is our table for bills
    @IBOutlet weak var table: UITableView!
    
    // These are the three arrays that display what is in the table
    var billName = ["Rent","Water"]
    var billTotal = ["400","50"]
    var billDue = ["10/05/2016","10/06/2016"]
    

    
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
        return items.count
    }
    
   //Create table edited so theres a slide left/right function
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
            self.billName.removeAtIndex(indexPath.row)
            self.billTotal.removeAtIndex(indexPath.row)
            self.billDue.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            return true
        })
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        
        
        return cell
    }
    
    //this function will be used to remove items
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
   
    }
    
    func configureCell(cell: MGSwipeTableCell, indexPath: NSIndexPath){
        let dict = items[indexPath.row]
        
        let bName = dict["billName"] as? String
        let bTotal = dict["billTotal"] as? String
        let bDue = dict["billDue"] as? String
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = bName
        cell.detailTextLabel!.text = bTotal! + " dollars owed by " + bDue!
        
        
    }
}

