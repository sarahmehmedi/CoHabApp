//
//  GroupChatTableViewCell.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 4/25/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit

class GroupChatTableViewCell: UITableViewCell {

    let backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(groupChat: NSDictionary)
    {
        //take square imageview and make it into a circle
        //get layer of avatar image view and set corner values
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2 //divide frame size width
        avatarImageView.layer.masksToBounds = true //don't let image exceed bounds of imageview
        
        //set avatar image in imageview
        self.avatarImageView.image = UIImage(named: "avatarPlaceHolder")
        
        //use this to get the user from backendless
        let withUserID = (groupChat.objectForKey("withUserUserId") as? String)!
        
        //query all users in backendless with the ID for this user and download avatar
        
        let whereClause = "objectId = '\(withUserID)'"//create where clause with object ID for user
        let dataQuery = BackendlessDataQuery() //create database query
        dataQuery.whereClause = whereClause //set query clause
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())//use backendless persistence service to specify class
        //use the persistence service to search the dataquery to get the response, which is a backendless collection of users from backendless users table
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
        let withUser = users.data.first as! BackendlessUser //downcast returned object from backendless user class as backendless user
            //use withUser to get the user's avatar
            
        }) { (fault: Fault!) -> Void in
            print("error, couldn't get user avatar \(fault)")

        }
        nameLabel.text = groupChat["withUserUsername"] as? String
        lastMessageLabel.text = groupChat["lastMessage"] as? String
        counterLabel.text = ""
        if((groupChat["counter"] as? Int)! != 0)
        {
            counterLabel.text = "\(groupChat["counter"]!) New"
        }
        
        let date = dateFormatter().dateFromString((groupChat["date"] as? String)!) //get date
        let seconds = NSDate().timeIntervalSinceDate(date!) //count seconds
        dateLabel.text = timeElapsed(seconds)
        
    }
    
    //elapsed function for dateLabel(remove later)
    func timeElapsed(seconds: NSTimeInterval) -> String
    {
        let elapsed: String?
        
        if (seconds < 60)
        {
            elapsed = "Just Now"
        }
        else if(seconds < 60 * 60)
        {
            let minutes = Int(seconds/60)
            
            var minText = "min"
            
            if (minutes > 1)
            {
                minText = "mins"
            }
            elapsed = "\(minutes) \(minText)"
        }
        else if(seconds < 24 * 60 * 60)
        {
            let hours = Int(seconds / (60 * 60))
            var hourText = "hour"
            if (hours > 1)
            {
                hourText = "hours"
            }
            elapsed = "\(hours) \(hourText)"
        }
        else
        {
            let days = Int(seconds / (24 * 60 * 60))
            var dayText = "day"
            if(days > 1)
            {
                dayText = "days"
            }
            elapsed = "\(days) \(dayText)"
        }
        return elapsed!
    }
}
