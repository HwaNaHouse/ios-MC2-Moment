//
//  CoreDataRealationshipViewModel.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
// https://www.youtube.com/watch?v=huRKU-TAD3g&t=2027s
import SwiftUI
import CoreData


class CoreDataRealationshipViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    
    @Published var categorys: [Category] = []
    @Published var pinLists: [Pin] = []
    @Published var photoLists: [Photo] = []
    @Published var selectCategory: Category?
    
    init() {
//        if !initStart {
            getCategorys()
            getPins()
            print("Init start")
//        }
       
    }
    
    
    func getCategorys() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        
//        let sort = NSSortDescriptor(keyPath: \Category.startDate, ascending: true)
//        request.sortDescriptors = [sort]
//
//        let filter = NSPredicate(format: "title == %@", "Apple")
//        request.predicate = filter
        
        
        
        //viewContext.fetch(Category.fetchRequest())
        
        do {
            categorys = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getPins() {
        let request = NSFetchRequest<Pin>(entityName: "Pin")
        
        do {
            pinLists = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getPhotos() {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        do {
            photoLists = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    
    func addCategorys() {
        let titleList = ["Jeju travel", "Pohang Travel", "New York Travel", "Awesome Canada", "뭘까", "이건","졸린데","자야지","이것만","하고","자야지"]
        let colorList = ["red", "blue", "black", "white", "purple", "yellow","pink","gray","silver","gold","red"]
        
        for i in 0..<11 {
            let newCategory = Category(context: manager.context)
            newCategory.title = titleList[i]
            newCategory.categoryColor = colorList[i]
            newCategory.startDate = Date()
            newCategory.endDate = Date()
            save()
        }
        print("Add Category")
        
    }
    
    func selectCategory(category: Category) {
        self.selectCategory = category
        print(category.title ?? "")
    }
    
    
    func addPins(inCategory: Category) {
        
        for i in 0..<11 {
            let newPin = Pin(context: manager.context)
            newPin.title = inCategory.title! + "\(i)" + "pin"
            newPin.createdAt = Date()
            newPin.category = inCategory
            newPin.emotion = "😀"
//            print(newPin.title ?? "")
            save()
        }
        print("addPin")
        
    }
    
    
    func addPhotos(toPins: Pin) {
        let newPhotos = Photo(context: manager.context)
        newPhotos.photoName = "0"
//        newPhotos. = toPins
//        newPhotos.inCategory = toPins.inCategory
        
        save()
    }
    
    func updateCategory(category: Category) {
//        let updateData = category
        save()
    }
    
    func deleteCategory(category: Category) {
        let category = category
        manager.context.delete(category)
        save()
    }
    
    func deletePin(pin: Pin) {
        let pin = pin
        manager.context.delete(pin)
        save()
    }
    
    func deletePhoto(photo: Photo) {
        let photo = photo
        manager.context.delete(photo)
        save()
    }
    
    func save() {
//        categorys.removeAll()
//        pinLists.removeAll()
//        photoLists.removeAll()
        self.manager.save()
        self.getCategorys()
        self.getPins()
        self.getPhotos()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.manager.save()
//            self.getCategorys()
//            self.getPins()
//            self.getPhotos()
//        }
    
    }
}
