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
        
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail");
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword");
        
        if(userEmailStored == userEmail){
            if (userPasswordStored == userPassword){
                //login succesful
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
            
            NSUserDefaults.standardUserDefaults().synchronize();
                self.dismissViewControllerAnimated(true, completion: nil);
            }
            else {displayMyAlertMessage("Invalid Password");}
        }
        else {displayMyAlertMessage("Invalid Username");
        }

    }
}
//
//        if(userEmail.isEmpty || userPassword.isEmpty) { return;}
//        
//        //send user data to server side
//        let myUrl = NSURL(string: "http://mysql.cs.luc.edu/~smehmedi/CohabApp/userLogin.php");
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "POST";
//        
//        let postString = "email=\(userEmail)&password=\(userPassword)";
//        
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
//            data, response, error -> Void in
//            
//            if error != nil{
//                print("error=\(error)")
//                return
//            }
//            
//            do{
//                
//                if let parseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
//                    
//                    print(error!.localizedDescription)
//                    print("json: \(parseJSON)");
//                    
//                    let resultValue = parseJSON["status"] as! String;
//                    print("result: \(resultValue)")
//                    
//                    if(resultValue=="Success"){
//                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
//                        NSUserDefaults.standardUserDefaults().synchronize();
//                        
//                        self.dismissViewControllerAnimated(true, completion: nil);
//                    })
//                    }
//                } catch let error as NSError{
//                    print(error)
//            }
//            }
//        
//        task.resume()
//    }
//}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
