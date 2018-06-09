//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 10/12/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit


public class Pin: NSManagedObject,MKAnnotation
{
    
    var isDownloading = false

    convenience init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext)
    {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        {
            self.init(entity: ent, insertInto: context)
            
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
    
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
    
    

}
