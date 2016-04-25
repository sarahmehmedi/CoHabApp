//
//  GroupChatViewController.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 4/25/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class GroupChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var groupChats: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1 //only going to have 1 section in table
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //dynamic, dependent on how many recent messages
        return groupChats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GroupChatTableViewCell
        let groupChat = groupChats[indexPath.row]
        cell.bindData(groupChat)        
        return cell
    }

    
    //MARK: IBActions
    
    @IBAction func newChatBarButtonPressed(sender: UIBarButtonItem) {
        //button calling the segue
        performSegueWithIdentifier("groupChatToChooseUserVC", sender: self)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //check segue
        if(segue.identifier == "groupChatToChooseUserVC")
        {
            let vc = segue.destinationViewController as! ChooseUserViewController
            //vc.delegate = self
        }
        /*
        if(segue.identifier == "groupChatToChooseUserVC")
        {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destinationViewController as! ChatViewController
            
            let groupChat = groupChats[indexPath.row]
            
            //set chatVC groupChat to the groupChat for chatroom
            chatVC.groupChat = groupChat
            chatVC.chatRoomId = groupChat["chatroomID"] as? String //set chatroom ID
            
        }*/
    }
    
    //MARK: ChooseUserDelegate
    /*
    //as soon as user taps cell to create chatroom with selected user
    func createChatroom(withUser: BackendlessUser)
    {
        let chatVC = ChatViewController()//instantiate chat view controller
        chatVC.hidesBottomBarWhenPushed = true //hide the bottom navigation bar from view when chat initiated
        
        //call the navigation controller to put to new created chat view controller on stack
        navigationController?.pushViewController(chatVC, animated: true)
        
        //set chatVC groupChat to the groupChat
        chatVC.withUser = withUser
        chatVC.chatRoomId = startChat(currentUser, user2:withUser) //generate chatroom ID using user ID
    }*/

    
}
