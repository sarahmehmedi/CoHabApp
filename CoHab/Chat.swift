//
//  Chat.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 4/25/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import Foundation
import Firebase

let firebase = Firebase(url: "https://cohabapp.firebaseio.com/")
let backendless = Backendless.sharedInstance()
let currentUser = backendless.userService.currentUser

//MARK: Create Chatroom

//function that takes 2 backendless users and combines their user ids to generate a chatroom ID to return as a string
func startChat(user1: BackendlessUser, user2: BackendlessUser) -> String
{
    //user 1 is current user
    let userId1: String = user1.objectId
    let userId2: String = user2.objectId
    
    var chatRoomId: String = "" //Store chatroom ID
    
    let value = userId1.compare(userId2).rawValue //compare user ID values
    
    if(value < 0)
    {
        chatRoomId = userId1.stringByAppendingString(userId2)
    }
    else
    {
        chatRoomId = userId2.stringByAppendingString(userId2)
    }
    let members = [userId1, userId2]
    //call function to create group chat
    createGroupChat(userId1, chatRoomID: chatRoomId, members: members, withUserUsername: user2.name!, withUseruserId: userId2)
    createGroupChat(userId2, chatRoomID: chatRoomId, members: members, withUserUsername: user1.name!, withUseruserId: userId1)
    
    return chatRoomId
}


//MARK: Create group chat item

//function to create a group chat
func createGroupChat(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUseruserId: String)
{
    firebase.childByAppendingPath("GroupChat").queryOrderedByChild("chatRoomID").queryEqualToValue(chatRoomID).observeSingleEventOfType(.Value, withBlock: { snapshot in //will run only once due to observeSingleEventType, since firebase is live database, so if we don't flag it as single, it'll push to users every change
        
        var createGroupChat = true
        //check for a result in snapshot (returned by query):
        if(snapshot.exists())
        {
            for groupChat in snapshot.value.allValues //go through all snapshot values
            {
                if(groupChat["userId"] as! String == userId) //if theres already a group chat with based user ID, don't make one
                {
                    createGroupChat = false
                }
            }
        }
        if(createGroupChat) //call function to create group chat item
        {
            createGroupChatItem(userId, chatRoomID: chatRoomID, members: members, withUserUsername: withUserUsername, withUserUserId: withUseruserId)
        }
    })
}
//function to create group chat item
func createGroupChatItem(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUserUserId: String)
{
    let reference = firebase.childByAppendingPath("GroupChat").childByAutoId() //generating auto ID from firebase
    let groupChatId = reference.key //taking generated auto ID, which is the key and adding it to group chat ID
    let date = dateFormatter().stringFromDate(NSDate()) //create date text from current date
    let groupChat = ["groupChatId" : groupChatId, "userId" : userId, "chatRoomID" : chatRoomID, "members" : members, "withUserUsername" : withUserUsername, "lastMessage" : "", "counter" : 0, "date" : date, "withUserUserId" : withUserUserId] //creating group chat dictionary from values
    //save group chat dictionary to firebase:
    reference.setValue(groupChat) { (error, reference) -> Void in
        if (error != nil)
        {
            print("error in creating group chat \(error)")
        }
    }
    
}
//MARK: Helper functions

private let dateFormat = "yyyyMMddHHmmss"

//date formatter:
func dateFormatter() -> NSDateFormatter
{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
