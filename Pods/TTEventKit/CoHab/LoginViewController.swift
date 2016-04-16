//
//  LoginViewController.swift
//  CoHab
//
//  Created by Christian  on 3/17/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let backendless = Backendless.sharedInstance()
    
    var email : String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: IBActions:
    
    @IBAction func loginBarButtonItemPressed(sender: UIBarButtonItem) {
        //check if user has input data in login fields
        if(emailTextField.text != "" && passwordTextField.text != "" )
        {
            //ProgressHUD.show("Logging in...") //Use ProgressHUD to show login status
            self.email = emailTextField.text
            self.password = passwordTextField.text
            //call function to login
            loginUser(email!, password: password!)
        }
        else
        {
            //use ProgressHUD to show login warning to user if text fields vacant or incorrectly filled
            //ProgressHUD.showError("All fields are required")
        }

    }
    
    //login function (should probably extract this out later to some higher level since it's used in both registration and log in)
    func loginUser(email: String, password: String)
    {
        //call backndless user login service to log user in
        backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
            //ProgressHUD.dismiss()
            //reset text fields on login
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
            //seque to home view
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeVC") as! UICollectionViewController
            
            self.presentViewController(vc, animated: true, completion: nil)
            //let vc = UIStoryboard(name : "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeVC") as! UITabBarController
            //to ensure the first default view upon entering is Home by using top bar button index
            //vc.selectedIndex = 0
            //self.presentViewController(vc, animated: true, completion: nil)
            
        }) { (fault : Fault!) -> Void in //report error
            print("couldn't log in user \(fault)")
        }
    }

    
    
}
