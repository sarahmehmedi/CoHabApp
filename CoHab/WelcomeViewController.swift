//
//  WelcomeViewController.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 4/16/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let backendless = Backendless.sharedInstance()
    var currentUser: BackendlessUser?
    
    //check if user has already logged in with a username and password, and if so, autolog them in
    override func viewWillAppear(animated: Bool) {
        backendless.userService.setStayLoggedIn(true)//tell backendless to keep user logged in, set to false if not
        
        currentUser = backendless.userService.currentUser
        
        //if user already in, take them to home page:
       if(currentUser != nil)
        {
            /*this part surrounding the segue is just because in the viewWillAppear method, when we're calling presentViewController, the view isn't appearing
             on the stack yet, and we're quickly doing the transition from this view to another, so to get rid of the compiler warning I'm wrapping this with
             dispatch to make it run on main queue
            */
            dispatch_async(dispatch_get_main_queue())
            {
                //segue to home view
                let vc = UIStoryboard(name : "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeVC")
              
                self.presentViewController(vc, animated: true, completion: nil)
            }

        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
