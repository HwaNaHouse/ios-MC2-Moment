//
//  WritingView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/14.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct WritingView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.date, ascending: false)], animation: .default) private var categories: FetchedResults<Category>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: MapViewModel
    @EnvironmentObject var cVM: CoreDataViewModel
    
    @State var pin: Pin
    @State var selection: Int
    @State private var isShow: Bool = false
    @State private var addressName: String = ""
    @Binding var isComplete: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .leading, spacing: 24) {
                
                Spacer().frame(height: 80)
                
                Text("핀 완성하기")
                    .font(.title).bold()
        
                Spacer().frame(height: 200)
                
                VStack(alignment: .leading) {
                    Text("카테고리 선택").bold()
                    Menu {
                        Picker(selection: $selection) {
                            ForEach(0..<categories.count, id: \.self) {
                                Text(categories[$0].unwrappedTitle)
                            }
                        } label: {}
                    } label: {
                        if categories.count != 0 {
                            MenuView(title: categories[selection].unwrappedTitle)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.gray)
                                )
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("핀 제목").bold()
                    Button {
                        isShow.toggle()
                    } label: {
                        textBorder(content: Text(addressName), isLeading: true)
                            .foregroundColor(.black)
                    }
                }
                .onChange(of: pin.latitude) { _ in
                    locate()
                }
                
                VStack(alignment: .leading) {
                    Text("날짜 조정하기").bold()
                    Button {
                        
                    } label: {
                        textBorder(
                            content:
                                HStack {
                                    Image(systemName: "calendar")
                                    DatePicker("", selection: $pin.date, displayedComponents: [.date, .hourAndMinute]).labelsHidden()
                                }
                            ,isLeading: true)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        textBorder(content: Text("취소하기").fontWeight(.black), isLeading: false)
                    }
                    
                    Button {
                        //edit완료 시 이동성
                        cVM.selection = selection
                        viewModel.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude), span: MapDetails.defaultSpan)
                        viewModel.isFirstShow = false
                        viewModel.isEdited = true
                        
                        
                        categories[selection].addToPin(pin)
                        isComplete = true //edit완료여부
                        presentationMode.wrappedValue.dismiss()
                    } label: {                        textBorder(content: Text("완료하기").fontWeight(.black), isLeading: false)
                    }
                }
                .font(.title3)
                .foregroundColor(.defaultColor)
                
                Spacer()
                Spacer().frame(height: 70)
            }
            .padding(23)
            
            VStack {
                Spacer().frame(height: isShow ? 0 : 170)
                ZStack {
                    EditMapView(pin: $pin, color: categories[selection].unwrappedColor, isShow: $isShow)
                        .frame(maxHeight: isShow ? .infinity : 150)
                        .mask(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(maxHeight: isShow ? .infinity : 150)
                        )
                    if !isShow {
                        Color.white.opacity(0.1)
                            .frame(maxHeight: 150)
                            .onTapGesture {
                                if !isShow {
                                    withAnimation {
                                        isShow.toggle()
                                    }
                                }
                            }
                    }
                }
                Spacer()
            }
            .padding(isShow ? 0 : 23)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear(perform: {
            locate()
        })
    }
    
    @ViewBuilder
    private func textBorder<Content: View>(content: Content, isLeading: Bool) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 44, alignment: isLeading ? .leading : .center)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(.white)
            )
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.gray)
            )
    }
    
    
    func locate() {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: pin.latitude, longitude: pin.longtitude), preferredLocale: Locale(identifier: "Ko_kr"), completionHandler: {(placemarks, error) in
            addressName = ""
            if let address: [CLPlacemark] = placemarks {
                if let admin: String = address.last?.administrativeArea {
                    if !self.addressName.contains(admin) {
                        self.addressName += "\(admin) "
                    }
                }
                if let locality: String = address.last?.locality {
                    if !self.addressName.contains(locality) {
                        self.addressName += "\(locality) "
                    }
                }
                if let name: String = address.last?.name {
                    if !self.addressName.contains(name) {
                        self.addressName += "\(name) "
                    }
                }
            }
            if self.addressName.isEmpty {
                self.addressName += "알 수 없는 주소"
            }
        })
    }
}

struct WritingView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newPin = Pin(context: viewContext)
        
        WritingView(pin: newPin, selection: 0, isComplete: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(MapViewModel())
            .environmentObject(CoreDataViewModel())
    }
}
