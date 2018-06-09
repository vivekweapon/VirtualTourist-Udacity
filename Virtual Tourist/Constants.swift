//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 11/12/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit
import Foundation

struct Constants
{
    struct Flickr
    {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let BBoxHalfWidth = 1.0
        static let BboxHalfheight = 1.0
        static let LatitudeRange = (-90.0,90.0)
        static let LongitudeRange = (-180.0,180.0)
    }
    
    struct FlickrParameterKeys
    {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJsonCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let Per_Page = "per_page"
    }
    
    struct FlickrParametersValues
    {
    
        static let Method = "flickr.photos.search"
        static let APIKey = "e86a1f8a8d13068a4341545a51bea638"
        static let ResponseFormat = "json"
        static let DisableJsonCallback = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        
    }
    
    
    
}
