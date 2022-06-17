//
//  MomentApp.swift
//  Moment
//
//  Created by 김민재 on 2022/06/10.
//

import SwiftUI

@main
struct MomentApp: App {
    
    let persistenceController = PersistenceController.shared
    
    let mapViewModel: MapViewModel = MapViewModel()
    let coreDataViewModel: CoreDataViewModel = CoreDataViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mapViewModel)
                .environmentObject(coreDataViewModel)
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
