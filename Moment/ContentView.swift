//
//  ContentView.swift
//  Moment
//
//  Created by 김민재 on 2022/06/10.
//

import SwiftUI
import CoreData
import MapKit


struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
    @EnvironmentObject var viewModel: MapViewModel
    
    @State private var isEnabled: Bool = true
    
    var body: some View {
        ZStack {
            MainView()
                .onAppear {
                    if categories.isEmpty {
                        withAnimation {
                            let newCategory = Category(context: viewContext)
                            newCategory.title = "일상 여행"
                            newCategory.categoryColor = "default"
                            newCategory.startDate = Date()
                            
                            PersistenceController.shared.saveContext()
                        }
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        if CLLocationManager.locationServicesEnabled() {
                            isEnabled = true
                            if viewModel.locationManager == Optional(nil) {
                                viewModel.checkIfLocationServicesIsEnabled()
                            }
                        } else {
                            isEnabled = false
                        }
                    }
                }
            
            if !isEnabled {
                MoveSettingView()
            } else {
                if viewModel.isShowingAlert {
                    MoveAuthView()
                }
            }
            OpeningView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MapViewModel())
            .environmentObject(CoreDataViewModel())
    }
}

