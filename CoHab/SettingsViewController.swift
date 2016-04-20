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

    var backendless = Backendless.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let user = self.backendless.userService.currentUser
        let groupID = user.getProperty("groupID") as? String
        print("groupID: \(groupID!)")
        
        if (groupID == nil){
            self.groupIDConfirmation.text = "you're not in a group "
        }
        else{
            self.groupIDConfirmation.text = "you're in group: \(groupID!)"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
