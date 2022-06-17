//
//  EditMapView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/14.
//

import SwiftUI
import MapKit

struct EditMapView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var pin: Pin
    @State private var annotation: [Pin] = []
    @State private var isActive: Bool = false
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    var color: String
    @Binding var isShow: Bool
    
    var body: some View {
        let width = UIScreen.main.bounds.width / 10
        
        ZStack {
            Map(coordinateRegion: $region, annotationItems: annotation) { pin in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude), content: {
                    EditPinView(pin: pin, color: color, annotations: annotation, isShow: isShow)
                })
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                annotation = [pin] //초깃값 세팅.
                region.center = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude)
            }
            
            if isShow {
                
                LoopingPinView()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Button {
                                annotation = [pin]
                                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude), span: MapDetails.defaultSpan)
                                withAnimation {
                                    isShow.toggle()
                                }
                            } label: {
                                sideButton("취소", color: .red)
                            }
                            
                            Button {
                                DispatchQueue.main.async {
                                    if annotation.count == 2 { //나갈 때. 수정했으면 수정한 거를 돌려주기.
                                        //                                    pin = annotation[1] //MARK: 왜 이렇게 넣어주면 뒤에 적용이 안되고, 아래처럼 명시적으로 넣어야하지?
                                        pin.emotion = annotation[1].emotion
                                        pin.date = annotation[1].date
                                        pin.latitude = annotation[1].latitude
                                        pin.longtitude = annotation[1].longtitude
                                    }
                                    annotation = [pin]
                                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude), span: MapDetails.defaultSpan)
                                    
                                    withAnimation {
                                        isShow.toggle()
                                    }
                                }
                                
                            } label: {
                                sideButton("완료", color: .defaultColor)
                            }
                        }
                        .padding()
                    }
                    
                    Button {
                        withAnimation {
                            isActive.toggle()
                        }
                    } label: {
                        if isActive {
                            Circle()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                                .overlay(
                                    Image(systemName: "xmark")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                )
                        } else {
                            Circle()
                                .frame(width: 71, height: 71)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
                                .overlay(
                                    Image("redpin")
                                )
                        }
                    }
                    .background(
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
                    )
                    Spacer().frame(height: UIScreen.main.bounds.height / 12)
                }
            }
        }
    }
    
    private func makeNewPin(emotion: String) {
        let newPin = Pin(context: viewContext)
        newPin.emotion = emotion
        newPin.date = pin.date
        newPin.latitude = region.center.latitude
        newPin.longtitude = region.center.longitude
        
        withAnimation {
            if annotation.count == 1 {
                annotation.append(newPin)
            } else if annotation.count == 2 {
                annotation.removeFirst()
                annotation.append(newPin)
            }
        }
    }
    
    @ViewBuilder
    private func sideButton(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.title2.bold())
            .foregroundColor(color)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(.white)
            )
    }
    
    @ViewBuilder
    private func makeButton(_ emotion: String, offset: CGFloat) -> some View {
        Button {
            withAnimation {
                makeNewPin(emotion: emotion)
                self.isActive.toggle()
            }
        } label: {
            Image(emotion)
                .resizable()
                .frame(width: 28, height: 28) //깨짐 방지.
                .padding()
        }
        .opacity(isActive ? 1 : 0)
        .offset(x: isActive ? offset : 0)
    }
}

struct EditPinView: View {
    var pin: Pin?
    var color: String
    var annotations: [Pin] = []
    var isShow: Bool
    
    var body: some View {
        if annotations.count == 1 {
            makePin(pin!.emotion ?? "smile", text: "현재 핀", textColor: .defaultColor, opacity: 0, isShow: isShow)
        } else {
            if pin == annotations[0] {
                makePin(pin!.emotion ?? "smile", text: "이전 핀", textColor: .red, opacity: 0.4, isShow: isShow)
            } else if pin == annotations[1] {
                makePin(pin!.emotion ?? "smile", text: "현재 핀", textColor: .defaultColor, opacity: 0, isShow: isShow)
            }
        }
    }
    
    @ViewBuilder
    private func makePin(_ emotion: String, text: String, textColor: Color, opacity: Double, isShow: Bool) -> some View {
        ZStack {
            Image(emotion)
                .resizable()
                .frame(width: 23, height: 23) //깨짐 방지.
                .background(
                    Circle()
                        .fill(Color(color))
                        .frame(width: 30, height: 30)
                )
                .padding()
            if isShow {
                ZStack {
                    Circle()
                        .fill(.black.opacity(opacity))
                        .frame(width: 30, height: 30)
                        .offset(x: -0.5, y: 0.7)
                    Text(text).bold()
                        .foregroundColor(textColor)
                        .offset(y: 30)
                }
            }
        }
    }
}
