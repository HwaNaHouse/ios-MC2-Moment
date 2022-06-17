//
//  PinView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//
//  MapView의 Annotation으로 들어간 PinView
//

import SwiftUI
import MapKit

struct PinView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: MapViewModel
    var pin: Pin
    @Binding var currentPin: Pin?
    var color: String
    @Binding var offset: CGPoint
    @Binding var isRemove: Bool //Try Debugging
    //end
    
    var body: some View {
        let width = UIScreen.main.bounds.width/10
        ZStack {
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                    currentPin = pin
                    viewModel.pinLocation(pin)
                }
            } label: {
                if pin == currentPin {
                    Text(pin.unwrappedEmotion)
                        .font(.system(size: 28))
                        .background(
                            PurplePin(color: Color(color))
                                .offset(y: 4)
                        )
                        .frame(width: 44, height: 44)
                        .offset(y: -22)
                        .padding()
                } else {
                    Text(pin.unwrappedEmotion)
                        .font(.system(size: 23))
                        .frame(width: 44, height: 44) //깨짐 방지.
                        .background(
                            Circle()
                                .fill(Color(color))
                                .frame(width: 30, height: 30)
                                .offset(x: -0.5, y: 0.7)
                        )
                        .padding()
                }
            }
            .overlay(
                GeometryReader { geo -> Color in
                    if isRemove {
                        if Date().timeIntervalSince(pin.createdAt) <= 2.0 { //Try Debugging
                            DispatchQueue.main.async {
                                self.offset = CGPoint(x: geo.frame(in: .global).midX+7, y: geo.frame(in: .global).minY-width*2.3)
                            }
                        }
                    }
                    return .clear
                }
            )
        }
    }
    }

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let pin1 = Pin(context: viewContext)
        pin1.title = "Jeju"
        pin1.createdAt = Date()
        pin1.latitude = 123.0012
        pin1.longtitude = 34.234
        pin1.emotion = "😁"
        
        return PinView(pin: pin1, currentPin: .constant(pin1), color: "red", offset: .constant(CGPoint(x: 100, y: 100)), isRemove: .constant(true))
            .environmentObject(MapViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
