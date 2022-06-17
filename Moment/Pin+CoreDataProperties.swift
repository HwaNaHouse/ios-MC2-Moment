//
//  Pin+CoreDataProperties.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/16.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var emotion: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var title: String?
    @NSManaged public var category: Category?
    @NSManaged public var photo: NSSet?

    public var unwrappedEmotion: String {
        emotion ?? "Unknown emotion"
    }
    public var unwrappedPlaceName: String {
        title ?? "Unknown placeName"
    }
    public var unwrappedContents: String {
        content ?? "Unknown Contents"
    }
    public var photoArray: Set<Photo> {
        let photoSet = photo as? Set<Photo> ?? []
        
        return photoSet
    }
}

// MARK: Generated accessors for photo
extension Pin {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}

extension Pin : Identifiable {

}
