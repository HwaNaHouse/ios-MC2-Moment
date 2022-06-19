//
//  Category+CoreDataProperties.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/16.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryColor: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var pin: NSSet?
    @NSManaged public var photo: NSSet?
    
    public var unwrappedCategoryColor: String {
        categoryColor ?? "default"
    }
    public var unwrappedTitle: String {
        title ?? "UnNamed"
    }
    public var pinArray: [Pin] {
        let pinSet = pin as? Set<Pin> ?? []
        
        return pinSet.sorted {
            $0.createdAt > $1.createdAt
        }
    }
    
    public var photoArray: [Photo] {
        let photoSet = photo as? Set<Photo> ?? []
        
        return photoSet.sorted {
            $0.photoName ?? "" < $1.photoName ?? ""
        }
    }

}

// MARK: Generated accessors for Pin
extension Category {

    @objc(addPinObject:)
    @NSManaged public func addToPin(_ value: Pin)

    @objc(removePinObject:)
    @NSManaged public func removeFromPin(_ value: Pin)

    @objc(addPin:)
    @NSManaged public func addToPin(_ values: NSSet)

    @objc(removePin:)
    @NSManaged public func removeFromPin(_ values: NSSet)
    
    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

}

extension Category : Identifiable {

}
