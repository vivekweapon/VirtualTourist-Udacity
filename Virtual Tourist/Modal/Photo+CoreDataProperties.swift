//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 30/01/2018.
//  Copyright © 2018 Flying Fish Studios. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var author: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var image: NSData?
    @NSManaged public var pin: Pin?
}
