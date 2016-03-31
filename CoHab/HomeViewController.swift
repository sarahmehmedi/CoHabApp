//
//  HomeViewController.swift
//  CoHab
//
//  Created by Dominique Allen on 3/18/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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