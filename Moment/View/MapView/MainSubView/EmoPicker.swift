//
//  EmoPicker.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//

import SwiftUI

struct EmoPicker: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: MapViewModel
    @ObservedObject var category: Category
    @State var emotion: String = ""
    @Binding var isActive: Bool
    @Binding var newPin: Pin?
    @Binding var isRemove: Bool
    
    var body: some View {
        let width = UIScreen.main.bounds.width / 10
        
        ZStack {
            makeButton("smile", offset: -width*3.4)
            makeButton("love", offset: -width*2)
            makeButton("sad", offset: width*2)
            makeButton("soso", offset: width*3.4)
        }
        .background(
            Capsule()
                .foregroundColor(.white)
                .frame(width: isActive ? width*9 : 70, height: 70)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
        )
    }
    
    @ViewBuilder
    private func makeButton(_ emotion: String, offset: CGFloat) -> some View {
        Button {
            withAnimation {
                self.emotion = emotion
                self.isActive.toggle()
                addPin()
            }
        } label: {
            Image(emotion)
                .resizable()
                .frame(width: 28, height: 28)
        }
        .opacity(isActive ? 1 : 0)
        .offset(x: isActive ? offset : 0)
    }
    
    private func addPin() {
        withAnimation {
            let newPin = Pin(context: viewContext)
            newPin.emotion = emotion
            newPin.createdAt = Date()
            newPin.latitude = viewModel.region.center.latitude
            newPin.longtitude = viewModel.region.center.longitude
            
            category.addToPin(newPin)
            PersistenceController.shared.saveContext()
            
            self.newPin = newPin
            self.isRemove = true
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.isRemove = false
            }
        }
    }
}

struct EmoPicker_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newCategory = Category(context: viewContext)
        newCategory.title = "Apple"
        
        let newPin = Pin(context: viewContext)
        return EmoPicker(category: newCategory, isActive: .constant(false), newPin: .constant(newPin), isRemove: .constant(true))
            .environmentObject(MapViewModel())
    }
}
