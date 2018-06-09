//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 10/12/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pageCount: Int64
    @NSManaged public var album: NSSet?

}

// MARK: Generated accessors for album
extension Pin {

    @objc(addAlbumObject:)
    @NSManaged public func addToAlbum(_ value: Photo)

    @objc(removeAlbumObject:)
    @NSManaged public func removeFromAlbum(_ value: Photo)

    @objc(addAlbum:)
    @NSManaged public func addToAlbum(_ values: NSSet)

    @objc(removeAlbum:)
    @NSManaged public func removeFromAlbum(_ values: NSSet)

}
