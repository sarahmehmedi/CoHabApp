//
//  HomeViewController.swift
//  CoHab
//
//  Created by Dominique Allen on 3/18/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class HomeViewController: UIViewController {
    
    
    @IBAction func helpButton(sender: AnyObject) {
        performSegueWithIdentifier("helpButton", sender: self)
    }
    var menuView: BTNavigationDropdownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = ["Home", "Tasks", "Myschedule", "Bills", "Group", "Building"]
       
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
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
            if (indexPath == 1){
                self.performSegueWithIdentifier("taskView", sender: self)
            }
            if (indexPath == 2){
                self.performSegueWithIdentifier("calendarView", sender: self)
            }
            if (indexPath == 3){
                self.performSegueWithIdentifier("billsView", sender: self)
            }
            
        }
        self.navigationItem.titleView = menuView
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // This is just a funciton that displays an alert message for when you mess something up
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    

    
    
    // This is what happens when you logout, it just changed the key to false and switches you to the login screen
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        self.performSegueWithIdentifier("loginview", sender: self)
    }
    
    @IBAction func onMyScheduleClick(sender: AnyObject) {
        
    }
    
    @IBAction func onTasksClick(sender: AnyObject) {
        
    }
    
    @IBAction func onBillsClick(sender: AnyObject) {
        
    }
    
    @IBAction func onCalendarClick(sender: AnyObject) {
        
    }
    
    @IBAction func onGroupClick(sender: AnyObject) {
        
    }
    
    @IBAction func onBuildingReportsClick(sender: AnyObject) {
        
    }
    
    @IBAction func onSettingsClick(sender: AnyObject) {
        
    }
    
}