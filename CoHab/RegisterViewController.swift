//
//  RegisterViewController.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 4/16/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var backendless = Backendless.sharedInstance() //Backendless instance needed below
    var newUser: BackendlessUser?
    var email: String?
    var username: String?
    var password: String?
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUser = BackendlessUser() //created new user in backendless
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: IBActions
    
    
    @IBAction func registerBarButtonItemPressed(sender: UIBarButtonItem) {
        if(emailTextField.text != "" && usernameTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "")
        {
            
            if(passwordTextField.text != repeatPasswordTextField.text)
            {
                //NONMATCHING PASSWORDS WARNING
                ProgressHUD.showError("Password fields do not match")
                
            }
            else
            {
                ProgressHUD.show("Registering...") //Use ProgressHUD to show registration status
                email = emailTextField.text
                username = usernameTextField.text
                password = passwordTextField.text
                
                //call register function to register backendless user
                register(self.email!, username: self.username!, password: self.password!, avatarImage: self.avatarImage)
            }
        }
        else
        {
            //MISSING FIELDS WARNING
            ProgressHUD.showError("All fields are required")
        }

    }
    
     
    //MARK: Backendless user registration
    
    /*takes email, username, password string and optional UIIMage avatar image. Call to register new user. Note that we can just use .email, .password and .username on values because they're the default values of our server and defined in SDK, but for any custom properties use .setProperty for the value*/
    func register(email: String, username: String, password: String, avatarImage: UIImage?)
    {
        if(avatarImage == nil)
        {
            newUser!.setProperty("Avatar", object: "") //dynamically creating new property in backendless for this user. Use this sort of syntax to make new properties. Since they're non-default properties though they need to always use setProperty, getProperty methods, whereas the default properties of username, password, and such can be accessed directly as below
        }
        
        //else if avatar image passed: (Going to add later)
        
        //unwrap optional newUser and set other passed property values():
        newUser!.email = email
        newUser!.name = username
        newUser!.password = password
        
        //call backendless registration service to register the new user:
        backendless.userService.registering(newUser, response: { (registeredUser: BackendlessUser!) -> Void in
            
            //dismiss the ProgressHUD registering status animation
            //ProgressHUD.dismiss()
            
            //because backendless doesn't automatically log in a newly registered user, call our function to log them in:
            self.loginUser(email, username: username, password: password) //keep the self here because function won't be called on main frame, called after registration
            ProgressHUD.dismiss()//dismiss ProgressHUD notification
            //clear text fields after login:
            
            self.passwordTextField.text = ""
            self.emailTextField.text = ""
            self.repeatPasswordTextField.text = ""
            self.usernameTextField.text = ""
            
        }) {(fault : Fault!) -> Void in //error handler to print backendless specific error on fail
            print("Server reported an error, couldn't register new user: \(fault)")
        }
        
    }
    
    func loginUser(email: String, username: String, password: String)
    {
        //call the login function of backendless:
        backendless.userService.login(email, password: password, response: {(user : BackendlessUser!) -> Void in
            //here we segue to homeview vc
            let vc = UIStoryboard(name : "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeVC") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        }) { (fault :Fault!) -> Void in //error handler to print backendless specific error on fail
            print("Server reported an error: \(fault)")
        }
    }
    
}