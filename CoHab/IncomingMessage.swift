//
//  IncomingMessage.swift
//  CoHab
//
//  Created by Shan-e-Ali Shah on 5/2/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import Foundation
import JSQMessagesViewController

class IncomingMessage
{
    var collectionView: JSQMessagesCollectionView
    
    init(collectionView_: JSQMessagesCollectionView)
    {
        collectionView = collectionView_
    }
    
    func createMessage(dictionary: NSDictionary) -> JSQMessage?
    {
        var message: JSQMessage?
        let type = dictionary["type"] as? String
        
        if(type == "text")
        {
            //create text message
            message = createTextMessage(dictionary)
        }
        if(type == "location")
        {
            //create location message
            message = createLocationMessage(dictionary)
        }
        if(type == "picture")
        {
            //create picture message
            message = createPictureMessage(dictionary)
        }
        if let mes = message
        {
            return mes
        }
        return nil
    }
    
    func createTextMessage(item: NSDictionary) -> JSQMessage
    {
        let name = item["senderName"] as? String
        let userId = item["senderId"] as? String
        let date = dateFormatter().dateFromString((item["date"] as? String)!)
        let text = item["message"] as? String
        
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, text: text)
    }
    
    func createLocationMessage(item: NSDictionary) -> JSQMessage
    {
        let name = item["senderName"] as? String
        let userId = item["senderId"] as? String
        let date = dateFormatter().dateFromString((item["date"] as? String)!)
        let latitude = item["latitude"] as? Double
        let longitude = item["longitude"] as? Double
        let mediaItem = JSQLocationMediaItem(location: nil)
        mediaItem.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusFromUser(userId!)
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        mediaItem.setLocation(location) { () -> Void in
            //update the collectionView
            self.collectionView.reloadData()
        }
        
        return JSQMessage(senderId: userId!, senderDisplayName: name!, date: date, media: mediaItem)

    }
    
    func returnOutgoingStatusFromUser(senderId: String) -> Bool
    {
        if(senderId == currentUser.objectId)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func createPictureMessage(item: NSDictionary) -> JSQMessage
    {
        let name = item["senderName"] as? String
        let userId = item["senderId"] as? String
        let date = dateFormatter().dateFromString((item["date"] as? String)!)
        let mediaItem = JSQPhotoMediaItem(image: nil)
        mediaItem.appliesMediaViewMaskAsOutgoing = returnOutgoingStatusFromUser(userId!)
        imageFromData(item) { (image: UIImage?) -> Void in
            mediaItem.image = image
            self.collectionView.reloadData()
        }
        
        return JSQMessage(senderId: userId!, senderDisplayName: name!, date: date, media: mediaItem)
    }
    
    //convert picture back from string to media
    func imageFromData(item: NSDictionary, result: (image: UIImage?) -> Void)
    {
        var image: UIImage?
        let decodedData = NSData(base64EncodedString: (item["picture"] as? String)!, options: NSDataBase64DecodingOptions(rawValue: 0))
        image = UIImage(data: decodedData!)
        result(image: image)
    }
    
}