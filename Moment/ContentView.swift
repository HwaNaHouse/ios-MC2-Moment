//
//  ContentView.swift
//  Moment
//
//  Created by 김민재 on 2022/06/10.
//

import SwiftUI
//import CoreData


struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.date, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
    
    var body: some View {
        MainView()
        .onAppear {
            if categories.isEmpty {
                withAnimation {
                    let newCategory = Category(context: viewContext)
                    newCategory.title = "일상 여행"
                    newCategory.color = "default"
                    newCategory.date = Date()

                    PersistenceController.shared.saveContext()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MapViewModel())
    }
}

