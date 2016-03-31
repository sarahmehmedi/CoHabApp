//
//  ViewController.swift
//  CoHab
//
//  Created by Christian  on 3/16/16.
//  Copyright © 2016 Christian . All rights reserved.
//


// So this is your main CoHab view as of now I havn't done anything to it besides allow for a login button.

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        if (isUserLoggedIn == false){
        self.performSegueWithIdentifier("loginView", sender: self)
        }
        if (isUserLoggedIn == true)
        {
            self.performSegueWithIdentifier("homeView", sender: self)
        }
    }
}

