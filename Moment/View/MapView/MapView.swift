//
//  MapView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//
//
/*
  MapView
 
 - MainView의 SubView로 들어가있음.
 - 이 MapView에서는 Annotation으로 PinView가 연결되어있음.
 - 지도 가운데에 통통 튀는 보라색 핀이 이 MapView안에 있는 LoopingPinView임.
 */
//


import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var viewModel: MapViewModel
    @State private var cgPoints: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var category: Category
    @Binding var currentPin: Pin?
    var pinMode: Bool
    var isActive: Bool
    @Binding var offset: CGPoint
    @Binding var isRemove: Bool
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.region,
                interactionModes: [viewModel.canMove ? .all : .zoom],
                showsUserLocation: true,
                annotationItems: category.pinArray) { pin in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude)) {
                    PinView(pin: pin, currentPin: $currentPin, color: category.unwrappedCategoryColor, offset: $offset, isRemove: $isRemove)
                }
            }
                .onTapGesture {
                    currentPin = nil
                    print("Map이 Tap됨.")
                }
                .edgesIgnoringSafeArea(.all)
                .accentColor(.pink)
            
            if pinMode {
                if isActive {
                    Circle()
                        .fill(Color("\(category.unwrappedCategoryColor)"))
                        .frame(width: 30, height: 30)
                } else {
                    if currentPin == Optional(nil) {
                        LoopingPinView()
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newCategory = Category(context: viewContext)
        newCategory.title = "Apple"
        
        let pin1 = Pin(context: viewContext)
        pin1.title = "Jeju"
        pin1.createdAt = Date()
        pin1.latitude = 123.0012
        pin1.longtitude = 34.234
        
        newCategory.addToPin(pin1)
        
        return MapView(category: newCategory, currentPin: .constant(pin1), pinMode: true, isActive: true, offset: .constant(CGPoint(x: 0, y: 0)), isRemove: .constant(true))
            .environmentObject(MapViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
