//
//  LoginViewController.swift
//  CoHab
//
//  Created by Christian  on 3/17/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
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
    
    
    // This is just a funciton that displays an alert message for when you mess something up
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    
    
    // This is the function that is triggered when you tap on the login button
    // Basically it will tell you whether your sign in was valid or invalid and then will
    // Change the status of the app to logged in
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        
        if(userEmail?.isEmpty == true || userPassword?.isEmpty == true){
            let myAlert = UIAlertController(title: "Alert", message: "You left email or password blank! Please try again.", preferredStyle: UIAlertControllerStyle.Alert);
            let okAction = UIAlertAction(title: "Ok", style:UIAlertActionStyle.Default, handler:nil);
            myAlert.addAction(okAction);
            self.presentViewController(myAlert,animated:true, completion:nil);
        }
        
        //send user data to server side
        let myUrl = NSURL(string: "http://mysql.cs.luc.edu/~smehmedi/CohabApp/userLogin.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "email=\(userEmail!)&password=\(userPassword!)";
        
        print(postString);
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error -> Void in
            
            if error != nil{
                print("error=\(error)")
                return
            }
            
            do{
                if let parseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary{
                    
                    let resultValue = parseJSON["status"] as! String;
                    print("result: \(resultValue)")
                    
                    if (resultValue == "Success"){
                        //successful login
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
                        NSUserDefaults.standardUserDefaults().synchronize();
                        // self.dismissViewControllerAnimated(true, completion: nil);
                    }
                    else if (resultValue == "error"){
                        //                        let loginViewController = rootViewController as Cohab.LoginViewController;
                        //                        let activeViewCont = loginViewController.visibleViewController;
                        
                        //idk why this alert popup doesnt work so i commented it out for now - sarah
                        
                        /*
                         let errorAlert = UIAlertController(title: "Alert", message: "You left email or password blank! Please try again.", preferredStyle: UIAlertControllerStyle.Alert);
                         let returnAction = UIAlertAction(title: "Ok", style:UIAlertActionStyle.Default, handler:nil);
                         errorAlert.addAction(returnAction);
                         self.presentViewController(errorAlert,animated:true, completion:nil);
                         */
                        self.dismissViewControllerAnimated(false, completion: nil);
                        
                    }
                }
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume();
    }
}
