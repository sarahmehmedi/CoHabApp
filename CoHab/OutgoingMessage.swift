//
//  OutgoingMessage.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 5/2/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import Foundation
import Firebase

class OutgoingMessage
{
    private let firebase = Firebase(url: "https://cohabapp.firebaseio.com/Message")
    let messageDictionary: NSMutableDictionary
    //initializer for text message
    init(message: String, senderId: String, senderName: String, date: NSDate, status: String, type: String)
    {
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "senderId", "senderName", "date", "status", "type"])
    }
    //initializer for location message
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: NSDate, status: String, type: String)
    {
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "latitude", "longitude", "senderId", "senderName", "date", "status", "type"])
    }
    //initializer for picture message
    init(message: String, pictureData: NSData, senderId: String, senderName: String, date: NSDate, status: String, type: String)
    {
        let pic = pictureData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) //Firebase won't store a pic, so convert picture to string using base 64 encoding
        messageDictionary = NSMutableDictionary(objects: [message, pic, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "picture", "senderId", "senderName", "date", "status", "type"])
    }
    
    func sendMessage(chatRoomID: String, item: NSMutableDictionary)
    {
        let reference = firebase.childByAppendingPath(chatRoomID).childByAutoId() //get the chatroom ID, then generate ID automatically for the message
        item["messageId"] = reference.key //get the key and assign it
        reference.setValue(item)
        {
            (error, ref) -> Void in
            if (error != nil)
            {
                print("Error, couldn't send message")
            }
        }
        //send push notification to user (but dunno how to do this without paying for Apple Developer license. Need to research some free alternative later)
        
        UpdateGroupChats(chatRoomID, lastMessage: (item["message"] as? String)!)
        
    }
}