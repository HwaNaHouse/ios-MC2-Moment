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

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var pin: NSSet?
    
    public var unwrappedColor: String {
        color ?? "default"
    }
    public var unwrappedTitle: String {
        title ?? "Unknown category title"
    }
    public var pinArray: [Pin] {
        let pinSet = pin as? Set<Pin> ?? []
        
        return pinSet.sorted {
            $0.date < $1.date
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

}

extension Category : Identifiable {

}
