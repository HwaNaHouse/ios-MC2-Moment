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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
