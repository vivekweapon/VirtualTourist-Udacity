//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 30/01/2018.
//  Copyright © 2018 Flying Fish Studios. All rights reserved.
//
//

import Foundation
import CoreData


public class Photo: NSManagedObject
{

    convenience init(imageurl:String,pin:Pin,image:NSData,context:NSManagedObjectContext)
    {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        {
            self.init(entity: ent, insertInto: context)
            
            self.imageURL = imageurl
            self.pin = pin
            self.image = image
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
