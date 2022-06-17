//
//  CoreDataManager.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//  코어 데이터 매니저

import SwiftUI
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "Moment")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading CoreData: \(error)")
            } else {
                print("코어데이터인잇 성공")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("코어데이터 세이브성공")
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
            print("코어데이터 세이브성공")
        
    }
    
}
