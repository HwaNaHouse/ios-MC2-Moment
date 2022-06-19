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
    public var unwrappedCreatedAt: String {
        changeDateToString(date: createdAt)
    }
    
    public var photoArray: [Photo] {
        let photoSet = photo as? Set<Photo> ?? []
        
        return photoSet.sorted {
            $0.unwrappedPhotoName < $1.unwrappedPhotoName
        }
    }
    
    func changeDateToString(date: Date?) -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        result = dateFormatter.string(from: date ?? Date())
        
        return result
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
