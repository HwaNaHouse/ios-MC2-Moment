//
//  CoreDateViewModel.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/13.
//

import SwiftUI
import CoreData

final class CoreDataViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @AppStorage("currentCategory") var selection: Int = 0
    
//    @Published var currentPin: Pin? = nil
    
    
    //viewContext.fetch(Category.fetchRequest())
   
    
}
