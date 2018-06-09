//
//  APIService.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 01/12/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

enum Response<T>
{
    case Success(T)
    case Error(String)
}

class APIService:NSObject
{
    
    var downloadedImages = [UIImage]()
    var pageNumber = 1

    func getData(pin:Pin,completion: @escaping (Response<[[String:AnyObject]]>)->Void)
    {
        var numberOfPages = pin.pageCount
        
        if ( numberOfPages > 0)
        {
            numberOfPages = min(numberOfPages,(Int64(4000/25)))
            pageNumber = Int((arc4random_uniform(UInt32(numberOfPages)))) + 1
        }
        

        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParametersValues.Method,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParametersValues.ResponseFormat,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParametersValues.MediumURL,
            Constants.FlickrParameterKeys.NoJsonCallback: "1",
            Constants.FlickrParameterKeys.SafeSearch: "1",
            Constants.FlickrParameterKeys.BoundingBox: bboxString(pin: pin),
            Constants.FlickrParameterKeys.Page: pageNumber,
            Constants.FlickrParameterKeys.Per_Page:"25"
            ] as [String : AnyObject]
       
        var mutableParameters = parameters
        mutableParameters[Constants.FlickrParameterKeys.APIKey] = Constants.FlickrParametersValues.APIKey as AnyObject
       
        let urlString =  APIService.escapedParameters(parameters: mutableParameters as [String : AnyObject])
        
        guard let url = URL(string:urlString)
        else
        {
          return completion(Response.Error("Invalid URL."))
        }
        
        URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            
            guard  error == nil
            else
            {
               return completion(Response.Error((error?.localizedDescription)!))
            }
            
            guard let data = data
            else
            {
                return completion(Response.Error((error?.localizedDescription)!))
            }
            
            var parsedResult:AnyObject! = nil
            
            do            {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                let photodict = parsedResult["photos"] as! [String:AnyObject]
                let photos = photodict["photo"] as! [[String : AnyObject]]
                pin.pageCount = (photodict["pages"] as? Int64)!
                
                NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "pinFinishedDownloadNotification"), object: self) as Notification)
                
                completion(Response.Success(photos))
                
            }
            catch let error
            {
                
                completion(Response.Error(error.localizedDescription))
                
            }
        }.resume()
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String
    {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters
        {
            
            if(key != "" || value as! String != "")
            {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return  (components.url?.absoluteString)!
    }
    
    private func bboxString(pin:Pin) -> String
    {
        // ensure bbox is bounded by minimum and maximums
        let latitude = pin.latitude
        let longitude = pin.longitude
            let minimumLon = max(longitude - Constants.Flickr.BBoxHalfWidth, Constants.Flickr.LongitudeRange.0)
            let minimumLat = max(latitude - Constants.Flickr.BboxHalfheight, Constants.Flickr.LatitudeRange.0)
            let maximumLon = min(longitude + Constants.Flickr.BBoxHalfWidth, Constants.Flickr.LongitudeRange.1)
            let maximumLat = min(latitude + Constants.Flickr.BboxHalfheight, Constants.Flickr.LongitudeRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        
    }
}
