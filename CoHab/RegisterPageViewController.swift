//
//  RegisterPageViewController.swift
//  CoHab
//
//  Created by Christian  on 3/16/16.
//  Copyright © 2016 Christian . All rights reserved.
//

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
        
        // INSERT BETWEEN HERE ***
        
        // Store Data right now this is storing local data which is a problem********* emphasis on the problem, it works but
        // This should be hosted somewhere, at the very bottom of this is a long section of code I was playing with to try to set
        // up a database but I failed after like 200 attempts. If you want to play with it insert it between the sections I indicated 
        // and delete what is inbetween.
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail");
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword");
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Display Alert Message With Confirmation
        let myAlert = UIAlertController(title:"Alert", message:"Registration Is Succesful!", preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
        action in
        self.dismissViewControllerAnimated(true, completion: nil);
        }
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion: nil);
        
        // AND HERE ***
        
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




/*
let myURL = NSURL(string: "http://cohab.byethost22.com/userRegistration.php");
let request = NSMutableURLRequest(URL: myURL!);
request.HTTPMethod = "POST";

let postString="email=\(userEmail)&password=\(userPassword)";

request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);

let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
data, response, error -> Void in


if (error != nil){
print("error=\(error)")
return
}

do{
if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {

print(error!.localizedDescription)
print("json: \(json)");

let resultValue = json["status"] as! String;
print("Result: \(resultValue)")

var isUserRegistered:Bool = false;

if(resultValue=="Success"){
isUserRegistered = true;
}

var messageTodisplay:String = json["message"] as! String;

if(!isUserRegistered){
messageTodisplay = json["message"] as! String;
}

dispatch_async(dispatch_get_main_queue(), {

let myAlert = UIAlertController(title: "Alert", message:
messageTodisplay, preferredStyle: UIAlertControllerStyle.Alert);

let okaction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);

myAlert.addAction(okaction);

self.presentViewController(myAlert, animated:true, completion:nil);
})
}
}catch let error as NSError{
print(error)
}
}
task.resume();

}
*/


