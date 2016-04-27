//
//  SettingsViewController.swift
//  CoHab
//
//  Created by Christian  on 4/20/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var groupIDConfirmation: UILabel!
    @IBOutlet weak var joinGroupInput: UITextField!

    @IBOutlet weak var createGroupInput: UITextField!
    @IBAction func createGroupButton(sender: AnyObject) {
        let user = self.backendless.userService.currentUser
        let groupID = user.getProperty("groupID") as? String
        if (groupID != nil){
            let alertController = UIAlertController(title: "Hey!", message:
                "You're already in a group:", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            user.setProperty( "groupID", object: createGroupInput.text)
            backendless.userService.update(user);
            
        }
    }
    
    @IBAction func joinGroupButton(sender: AnyObject){
        
    }
    
    @IBAction func removeGroup(sender: AnyObject) {
        let user = self.backendless.userService.currentUser
        let groupID = user.getProperty("groupID") as? String
        if (groupID == nil){
            let alertController = UIAlertController(title: "Hey!", message:
                "You aren't in a group:", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
          user.removeProperty("groupID")
          backendless.userService.update(user);
        }
    }
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       var dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find()
        let user = self.backendless.userService.currentUser
        let groupID = user.getProperty("groupID") as? String
        print("groupID: \(groupID)")
        if (groupID == nil){
            self.groupIDConfirmation.text = "you're not in a group "
        }
        else{
            self.groupIDConfirmation.text = "you're in group: \(groupID!)"
        }
        //CALLS function below to print users to screen
        getUsersFromGroupID()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //this function queries all current users emails, I dont think the groupID is not attached to BackendlessUser
    func getUsersFromGroupID(){
        let query = BackendlessDataQuery()
        backendless.persistenceService.of(BackendlessUser.ofClass()).find(query, response: { (groupID : BackendlessCollection!) ->() in
            
            let currentPage = groupID.getCurrentPage()
            print("USERS COUNT: \(currentPage.count)")
            print("Current Users: \(groupID.totalObjects)")
            
            //maybe need to add groupID to BackendlessUser so that we can call it
            for id in currentPage as! [BackendlessUser]{
                print("Current User Emails: \(id.email)")
            }

            }, error: { ( fault: Fault!) -> () in
                print("error \(fault)")
            }
            
        )
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
