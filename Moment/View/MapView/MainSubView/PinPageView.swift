//
//  PinListView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//
//  PinPageView: Pin 눌렀을 때, 올라오는 하단의 Pager들을 관리하는 곳.
//  하단의 PageView: PinPageView를 구성하는 하나하나의 Page.
//

import SwiftUI
import SwiftUIPager //package source: https://github.com/fermoya/SwiftUIPager
import MapKit

struct PinPageView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @EnvironmentObject var cVM: CoreDataViewModel
    @ObservedObject var pageIndex: Page
    @ObservedObject var category: Category
    @Binding var currentPin: Pin?
    @Binding var isNavigationViewActive: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Pager(page: pageIndex, data: category.pinArray) {
                PageView(category: category, pin: $0, currentPin: $currentPin, isNavigationViewActive: $isNavigationViewActive)
            }
            .onPageWillChange { index in
                currentPin = category.pinArray[index]
                withAnimation(Animation.linear(duration: 0.1)) {
                    viewModel.region.center = CLLocationCoordinate2D(latitude: currentPin!.latitude, longitude: currentPin!.longtitude)
                }
            }
            .horizontal()
            .alignment(.center)
            .itemSpacing(-70)
            .frame(height: 180)
            .ignoresSafeArea()
        }
    }
}

//struct PinListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewContext = PersistenceController.preview.container.viewContext
//        let newCategory = Category(context: viewContext)
//
//        let newPin = Pin(context: viewContext)
//
//        PinPageView(pageIndex: .first(), category: newCategory, currentPin: .constant(newPin))
//            .environmentObject(MapViewModel())
//            .environmentObject(CoreDataViewModel())
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

extension Color {
    static let defaultColor = Color(#colorLiteral(red: 0.37858086824417114, green: 0.33240658044815063, blue: 0.9095856547355652, alpha: 1))
}

struct PageView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var cVM: CoreDataViewModel
    @ObservedObject var category: Category
    @State var pin: Pin //원본 핀
    @State private var editPin: Pin?
    @State private var isComplete: Bool = false
    @Binding var currentPin: Pin?
    @Binding var isNavigationViewActive: Bool

    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Spacer()
                HStack {
                    Text(pin.title ?? "Title Please")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(pin.title == Optional(nil) ? .secondary : .black)
                        .lineLimit(1)
                    Spacer()
                    Text(pin.unwrappedEmotion)
                        .font(.system(size: 23))
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .fill(
                                    Color("\(category.categoryColor ?? "")")
                                )
                                .frame(width: 30, height: 30)
                                .offset(x: -0.5, y: 0.7)
                        )
                }
                
                HStack {
                    let pinIndex = category.pinArray.firstIndex {
                        $0 == pin
                    }!
                    Circle()
                        .foregroundColor(.defaultColor)
                        .frame(width: 18, height: 18)
                        .overlay(Text("\(pinIndex+1)")
                            .font(.caption2)
                            .foregroundColor(.white))
                    Text(category.unwrappedTitle)
                        .font(.headline)
                        .foregroundColor(.defaultColor)
                    Spacer()
                }
                
                Spacer().frame(height: 25)
                if pin.title == Optional(nil) {
                    NavigationLink(destination: PinDetailAddView(), isActive: self.$isNavigationViewActive) {
                        bottomButton(pin)
                    }
                    .isDetailLink(false)
                } else {
                    NavigationLink(destination: Text("디테일뷰")) {  //MARK: Go to DetailView
                        bottomButton(pin)
                    }
                }
            }
            .padding(20)
            .background(.white)
            .frame(width: 300)
            .frame(height: 162)
            .cornerRadius(20)
        }
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
        .onAppear {
            if isComplete { //수정 완료 트리거
                currentPin = nil //TODO: 이거 좋은방법아니다~ 리팩토링하셈~!
                DispatchQueue.main.async {
                    deletePin()
                }
            } else {
                self.editPin = copyPin(pin) //복사본
            }
        }
    }
    
    private func copyPin(_ pin: Pin) -> Pin {
        let editPin = Pin(context: viewContext)
        editPin.emotion = pin.emotion
        editPin.createdAt = pin.createdAt
        editPin.latitude = pin.latitude
        editPin.longtitude = pin.longtitude
        
        return editPin
    }
    
    private func deletePin() {
        viewContext.delete(pin)
        
        PersistenceController.shared.saveContext()
    }
    
    @ViewBuilder
    private func bottomButton(_ pin: Pin) -> some View {
        HStack {
            Spacer()
            Text(pin.title == Optional(nil) ? "핀 완성하기" : "핀 확인하기")
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.vertical, 7)
        .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(Color.defaultColor))
    }
}
