//
//  CalendarViewController.swift
//  CoHab
//
//  Created by Dominique Allen on 3/19/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import TTEventKit
import BTNavigationDropdownMenu
import Firebase


class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: CalendarView!
    var menuView: BTNavigationDropdownMenu!
    
    @IBOutlet weak var header: UINavigationItem!
    
    let ref = Firebase(url:"https://cohabapp.firebaseio.com/events")
    let backendlessUser = Backendless.sharedInstance().userService.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = ["Home", "Tasks", "Calendar", "Bills", "Group", "Building"]
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[2], items: items)
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
        }
        self.navigationItem.titleView = menuView
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated:true);
        
//        calendarView.delegate = self
        calendarView.current.year = NSCalendar.currentCalendar().component(.Year, fromDate: NSDate())
        calendarView.current.month = NSCalendar.currentCalendar().component(.Month, fromDate: NSDate())
        
        let year = calendarView.current.year
        let month = calendarView.current.month
        changedMonth(year, month: month)
        
        EventStore.requestAccess() { (granted, error) in
            if !granted {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Error", message: "CoHab does not have access to your calendars.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.loadView()
                }
            }
        }
        
        let ev = EventStore.getEvents(Month(year: year, month: month))
        
        if ev  != nil {
            for e in ev {
                print("Title \(e.title)")
                print("startDate: \(e.startDate)")
                print("endDate: \(e.endDate)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedAddButton(sender: UIBarButtonItem) {
        
        let event = EventStore.create()
        event.title = "Test Event"
        event.startDate = NSDate()
        event.endDate = event.startDate
        event.notes = "This is a test event"
        event.location = "Loyola University Chicago"
        EventUI.showEditView(event)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        //creates dictionary of all pertinent event information
        let new: NSDictionary = ["eventTitle": event.title, "eventStart": dateFormatter.stringFromDate(event.startDate), "eventEnd": dateFormatter.stringFromDate(event.endDate), "eventNotes": event.notes!, "eventLocation": event.location!, "eventCreator": backendlessUser.email]
        //creates node for event in database
        let group = self.ref.childByAppendingPath(event.title)
        //adds event info to node
        group.setValue(new)
        
    }
    
    //=================================
    // Calendar Delegate
    //=================================
    
    func changedMonth(year: Int, month: Int) {
        let monthEn = ["January", "Febrary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        print("\(year) \(monthEn[month - 1])")
        
//        header.title = "\(year) \(monthEn[month - 1])"
        
    }
    
    func selectedDay(dayView: CalendarDayView) {
        
    }
    
}
