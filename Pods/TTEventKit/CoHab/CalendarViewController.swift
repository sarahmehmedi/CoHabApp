//
//  CalendarViewController.swift
//  CoHab
//
//  Created by Dominique Allen on 3/19/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import EventKit
import TTEventKit


class CalendarViewController: UIViewController, CalendarDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!
    
    @IBAction func calendarBackButton(sender: AnyObject) {
        performSegueWithIdentifier("calendarBackButton", sender: self)
    }
    @IBOutlet weak var header: UINavigationItem!
    
    override func viewDidLoad() {
        
        let flags: NSCalendarUnit = NSCalendarUnit.Year
        let currDate = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: currDate)
        
        super.viewDidLoad()
        
        calendarView.delegate = self
        
        calendarView.current.year = components.year
        calendarView.current.month = components.month
        
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
        EventUI.showEditView(event)
    }
    
    //=================================
    // Calendar Delegate
    //=================================
    
    func changedMonth(year: Int, month: Int) {
        let monthEn = ["January", "Febrary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
     //   header.title = "\(year) \(monthEn[month - 1])"
        
    }
    
    func selectedDay(dayView: CalendarDayView) {
        
    }
    
}
