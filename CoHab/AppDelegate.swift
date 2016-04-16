//
//  AppDelegate.swift
//  CoHab
//
//  Created by Christian  on 3/16/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  
    let APP_ID = "6C1725AD-9D6B-7881-FF33-84FB18E7D200"//Our application's generated ID from Backendless Management Dashboard.
    let SECRET_KEY = "D06229C5-B85F-B880-FF8F-86465F567000" //Our application's generated iOS-specific secret key from Backendless Management Dashboard. Can be regenerated
    let VERSION_NUM = "v1" //Backendless requries version number, so arbitrarily just calling our current build v1
    
    var backendless = Backendless.sharedInstance() //instance of backendless to be initialized later when application is launched
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM); //initializing our backendless instance with our secret keys
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

