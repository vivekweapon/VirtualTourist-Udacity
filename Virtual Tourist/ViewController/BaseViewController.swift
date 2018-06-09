//
//  BaseViewController.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 26/01/2018.
//  Copyright © 2018 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

public class BaseViewController
{
    static let shared = BaseViewController()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var userPin:Pin! = nil

    
    //MARK:GET PIN DATA
    func getPinData(pin:Pin,completionHandler: @escaping (AnyObject)->Void)
    {
        userPin = pin
        
        let service = APIService()
        service.getData(pin: pin)
        { (result) in
            switch result
            {
                
            case .Success(let data):
                self.saveInCoreDataWith(array: data)
                
            case .Error(let message):
                DispatchQueue.main.async
                {
                        completionHandler(message as AnyObject)
                }
                
            }
        }
    }
    
    //MARK:SAVE IN CORE DATA.
    private func saveInCoreDataWith(array: [[String: AnyObject]])
    {
        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
        
             appDelegate?.stack.save()
       
    }
    
    
    //MARK:CREATE PHOTO ENTITY.
    private func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject?
    {
        
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: (appDelegate?.stack.context)!) as? Photo {
            
            photoEntity.imageURL = dictionary["url_m"] as? String
            photoEntity.pin = userPin
            
            let photoURL = URL(string:dictionary["url_m"] as! String)
           
            DownloadFlickrImages.shared.downloadFlickrImagesFor(url: photoURL!, imageUrlCompletionHandler:
                { (imageData) in
                    photoEntity.image = imageData as? NSData
                })
            
            return photoEntity
        }
        
        return nil
    }
    
    //MARK:CREATE PIN ENTITY
    public func createPinEntity(locationCoordinate:CLLocationCoordinate2D)-> NSManagedObject?
    {
        
        if let pinEntity = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: (appDelegate?.stack.context)!) as? Pin
        {
            
            pinEntity.latitude = locationCoordinate.latitude
            pinEntity.longitude = locationCoordinate.longitude
            
            return pinEntity
        }
        
        return nil
    }
}
