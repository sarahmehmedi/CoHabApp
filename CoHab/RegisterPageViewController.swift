//
//  RegisterPageViewController.swift
//  CoHab
//
//  Created by Christian  on 3/16/16.
//  Copyright © 2016 Christian . All rights reserved.
//
import Alamofire
import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // This is what happens when you press the register button on the register screen after you have registered
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPassword = repeatPasswordTextField.text;
        
        
        func displayMyAlertMessage(userMessage:String)
        {
            let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil);
            
            myAlert.addAction(okAction);
            
            self.presentViewController(myAlert, animated: true, completion: nil);
        }
        
        // Check for empty fields
        if(userEmail?.isEmpty == true || userPassword?.isEmpty == true || userRepeatPassword?.isEmpty == true){
            
            // Display Alert Message
            displayMyAlertMessage("All Fields Are Required");
            return;
        }
        
        // Check If Passwords Match
        if (userPassword != userRepeatPassword)
        {
            // Alert 
            displayMyAlertMessage("Passwords Do Not Match");
            return;
        }
        
        //so REGISTRATION WORKS!!! the Login i have to modify to connect to database - sarah
    
        let myUrl = NSURL(string: "http://mysql.cs.luc.edu/~smehmedi/CohabApp/userRegister.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        print(request)
        let postString = "email=\(userEmail!)&password=\(userPassword!)";
        print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error -> Void in

            if error != nil{
                print("error=\(error)")
                return
            }
            print(response)
            
            do{
                print(data!)
            
                if let parseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary{
                    
//                    print(error!.localizedDescription)
                    print("json: \(parseJSON)");
                    
                    let resultValue = parseJSON["status"] as! String;
                    print("result: \(resultValue)")
                    
                    var isUserRegistered:Bool = false;
                    if(resultValue=="Success") { isUserRegistered = true; }

                    var messageToDisplay:String = parseJSON["message"] as! String;
                    if(!isUserRegistered){ messageToDisplay = parseJSON["message"] as! String; }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle:  UIAlertControllerStyle.Alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
                        
                        myAlert.addAction(okAction);
                        
                        self.presentViewController(myAlert, animated: true, completion: nil);
                    })
                    
                    }
                } catch let error as NSError{
                print(error)
            }
            }
            task.resume()
        
    }
}
