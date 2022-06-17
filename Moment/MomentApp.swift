//
//  MomentApp.swift
//  Moment
//
//  Created by 김민재 on 2022/06/10.
//

import SwiftUI

@main
struct MomentApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    
    let mapViewModel: MapViewModel = MapViewModel()
    let coreDataViewModel: CoreDataViewModel = CoreDataViewModel()
//    let viewModel = CoreDataRealationshipViewModel()
    let stateManage = StateManage()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mapViewModel)
                .environmentObject(coreDataViewModel)
                .environmentObject(stateManage)
//                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
