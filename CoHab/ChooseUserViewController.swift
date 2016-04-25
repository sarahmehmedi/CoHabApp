//
//  ChooseUserViewController.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 4/25/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class ChooseUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //var delegate: ChooseUserDelegate!
    var users: [BackendlessUser] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //start downloading users and generate table upon view
        loadUsers()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //dynamic, based on how many users in database
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    //MARK: UITableViewDelegate
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let user = users[indexPath.row]
        
        delegate.createChatroom(user)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)//dismiss the view upon user selection:
        
    }
    */
    //MARK: IBActions

    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Load Backendless Users
    
    func loadUsers()
    {
        let whereClause = "objectId != '\(currentUser.objectId)'" //set where clause
        let dataQuery = BackendlessDataQuery() //make query
        dataQuery.whereClause = whereClause //set query
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
            
            self.users = users.data as! [BackendlessUser] //downcast to backendless user
            //reload table view after user array retrieval:
            self.tableView.reloadData()
        }) { (fault : Fault!) -> Void in
            print("Error, couldn't retrieve users: \(fault)")
        }
    }
    
}
