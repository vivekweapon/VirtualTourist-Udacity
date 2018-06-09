//
//  DownloadFlickrImages.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 21/01/2018.
//  Copyright © 2018 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

public class DownloadFlickrImages
{
   static let shared = DownloadFlickrImages()
    
    public func downloadFlickrImagesFor(url:URL,imageUrlCompletionHandler: @escaping(AnyObject)->Void)
    {
        
        URLSession.shared.dataTask(with:url, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                return
            }
            DispatchQueue.main.async
                {
                    if let data = data
                    {
                        imageUrlCompletionHandler(data as NSData)
                    }
            }
        }).resume()
    }
}
