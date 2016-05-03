//
//  ChatRoomViewController.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 5/2/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatRoomViewController: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let ref = Firebase(url: "https://cohabapp.firebaseio.com/Message")
    var messages: [JSQMessage] = [] //array of messages
    var objects: [NSDictionary] = [] //hold dictionaries returned from database query
    var loaded: [NSDictionary] = []
    var withUser: BackendlessUser? //the user with whom you wanna chat. TO DO: After you get this working, try to figure out how to make it with multiple users
    var recent: NSDictionary?
    var chatRoomId: String!
    var initialLoadComplete: Bool = false
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor()) //set outgoing message color bubble
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.senderId = currentUser.objectId
        self.senderDisplayName = currentUser.name
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        //load firebase messages
        loadMessages()
        
        self.inputToolbar?.contentView?.textView?.placeHolder = "New Message" //set the placeholder text, should be new message by default, but just in case
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: JSQMessages data source functions
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView	, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let data = messages[indexPath.row]
        if data.senderId == currentUser.objectId //if outgoing
        {
            cell.textView?.textColor = UIColor.whiteColor()
        }
        else //if incoming
        {
            cell.textView?.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        let data = messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let data = messages[indexPath.row]
        if data.senderId == currentUser.objectId //if outgoing
        {
            return outgoingBubble
        }
        else
        {
            return incomingBubble
        }
    }
    
    //MARK: JSQMessages Delegate function
   
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        if(text != "") //if not empty message
        {
            //send the message
            sendMessage(text, date: date, picture: nil, location: nil)
        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!)
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)//alert controller
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("Take photo")
            Camera.PresentPhotoCamera(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) {(alert: UIAlertAction!) -> Void in
            print("photo library")
            Camera.PresentPhotoLibrary(self, canEdit: true)
        }
        let shareLocation = UIAlertAction(title: "Share Location", style: .Default) { (alert: UIAlertAction!) -> Void in
            //check if we have location access to prevent crash
            self.sendMessage(nil, date: NSDate(), picture: nil, location: "location")

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            print("Cancel")
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        //present the alert controller and 4 options:
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    //MARK: Send Message
    func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?)
    {
        var outgoingMessage = OutgoingMessage?()
        
        //if text message
        if let text = text
        {
            //send text message
            outgoingMessage = OutgoingMessage(message: text, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Delivered", type: "text")
        }
        
        //if picture message
        if let pic = picture{
            //send picture message
            let imageData = UIImageJPEGRepresentation(pic, 1.0)
            outgoingMessage = OutgoingMessage(message: "Picture", pictureData: imageData!, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Delivered", type: "picture")
        }
        if let loc = location{
            //send location message
            let lat: NSNumber = NSNumber(double: (appDelegate.coordinate?.latitude)!) //get latitude
            let lng: NSNumber = NSNumber(double: (appDelegate.coordinate?.longitude)!) //get longitude
            
            outgoingMessage = OutgoingMessage(message: "Location", latitude: lat, longitude: lng, senderId: currentUser.objectId!, senderName: currentUser.name!, date: date, status: "Delivered", type: "location")
        }
        
        //Play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        self.finishSendingMessage()
        
        //save message to firebase
        outgoingMessage!.sendMessage(chatRoomId, item: outgoingMessage!.messageDictionary)
    }
    
    //MARK: Load Messages
    func loadMessages() //set the messages array
    {
        ref.childByAppendingPath(chatRoomId).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            //get the dictionaries from firebase
            
            
            //then create JSQ messages with them
            self.insertMessages()
            self.finishReceivingMessageAnimated(true) //scrolls to latest message and plays sound
            self.initialLoadComplete = true
        })
        
        ref.childByAppendingPath(chatRoomId).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            if (snapshot.exists())
            {
                let item = (snapshot.value as? NSDictionary)!
                if (self.initialLoadComplete)
                {
                    //create JSQ messages and add them to our array of messages
                    let incoming = self.insertMessage(item)
                    if incoming
                    {
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                    self.finishReceivingMessageAnimated(true)
                }
                else
                {
                    //add each dictionary to loaded array
                    self.loaded.append(item)
                }
            }
        })
        //Optional portion for expanding chat functionality later to edit or delete messages. Don't have the time right now
        /*
        ref.childByAppendingPath(chatRoomId).observeEventType(.ChildChanged, withBlock: {
            snapshot in
            //updated message
        })
        ref.childByAppendingPath(chatRoomId).observeEventType(.ChildRemoved, withBlock: {
            snapshot in
            //deleted message
        })
        */
    }
    
    //MARK: functions to sort firebase dictionaries
    func insertMessages()
    {
        for item in loaded
        {
            //create message
            insertMessage(item)
        }
    }
    
    func insertMessage(item: NSDictionary) -> Bool
    {
        let incomingMessage = IncomingMessage(collectionView_: self.collectionView!) //create incoming message
        let message = incomingMessage.createMessage(item)
        objects.append(item)
        messages.append(message!)
        
        return incoming(item)
    }
    
    func incoming(item: NSDictionary) -> Bool
    {
        //check using sender ID
        if(self.senderId == item["senderId"] as! String)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func outgoing(item: NSDictionary) -> Bool
    {
        if(self.senderId == item["senderId"] as! String)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: Helper functions
    
    //location access checker
    func haveAccessToLocation() -> Bool
    {
        if let location = appDelegate.coordinate?.latitude
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: UIImagePickerController functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let picture = info[UIImagePickerControllerEditedImage] as! UIImage
        self.sendMessage(nil, date: NSDate(), picture: picture, location: nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
