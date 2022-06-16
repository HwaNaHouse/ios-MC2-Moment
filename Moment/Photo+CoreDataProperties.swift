//
//  Photo+CoreDataProperties.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/16.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imagePath: String?
    @NSManaged public var Pin: Pin?

}

extension Photo : Identifiable {

}
