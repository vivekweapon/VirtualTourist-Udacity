//
//  VirtualTouristAlert.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 26/01/2018.
//  Copyright © 2018 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

public class VirtualTouristAlert
{
    static let shared = VirtualTouristAlert()
    
    public func presentAlertView(ViewController:UIViewController!, alertTitle:String!, alertMessage:String!,completionHandler:@escaping (Bool)->Void)
    {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let Action = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default)
        { (action) in
            completionHandler(true)
        }
        
        alert.addAction(Action)
        ViewController.present(alert, animated: true, completion: nil)
    }
    
    public func presentAlertWithCancelAndOkButton(ViewController:UIViewController,alertTitle:String!,alertMessage:String!,alertCompletionHandler:@escaping (Bool)->Void)
    {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default)
        { (action) in
            alertCompletionHandler(true)
        }
        
        let cancelAction = UIAlertAction(title:"Cancel",style:UIAlertActionStyle.default)
        { (action) in
            alertCompletionHandler(false)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        ViewController.present(alert, animated: true, completion: nil)
    }
    
}

