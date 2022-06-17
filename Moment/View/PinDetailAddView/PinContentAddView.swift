//
//  PinContentAddView.swift
//  Moment
//
//  Created by 김민재 on 2022/06/13.
//

import SwiftUI
import MapKit
import CoreLocation

/*
 * 컨텐츠 추가 뷰
 * 이전 단계로 : 이전 뷰로 이동
 * 핀 완료하기 : 뷰 스택 종료
 */

struct PinContentAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: false)], animation: .default) private var categories: FetchedResults<Category>

    @EnvironmentObject var viewModel: MapViewModel
    @EnvironmentObject var cVM: CoreDataViewModel
    
    @Binding var pin: Pin
    @Binding var selection: Int
    @Binding var pinName: String
    @Binding var isComplete: Bool
    @Binding var selectedImages: [UIImage]
    
    @State var pinContent: String = ""
    
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: UIScreen.main.bounds.size.height * 0.02)
            
            TextEditor(text: $pinContent)
                .font(.body)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
            
            Text(pin.content ?? "메모 없음")

            Spacer()
                .frame(height: UIScreen.main.bounds.size.height * 0.05)
            
            HStack(spacing: UIScreen.main.bounds.size.width * 0.041) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("이전 단계로")
                }
                .buttonStyle(PreviousButtonStyle())
                
                Button(action: {
                    pin.title = pinName.count == 0 ? nil : pinName
                    pin.content = pinContent.count == 0 ? nil : pinContent
                    cVM.selection = selection
                    viewModel.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longtitude), span: MapDetails.defaultSpan)
                    viewModel.isFirstShow = false
                    viewModel.isEdited = true
                    categories[selection].addToPin(pin)
                    isComplete = true
                    
                    self.rootPresentationMode.wrappedValue.dismiss()
                }) {
                    Text("핀 완료하기")
                }
                .buttonStyle(NextButtonStyle())
            }
        }
        .padding(UIScreen.main.bounds.size.width * 0.059)
        .navigationBarTitle("메모 작성하기")
        .navigationBarBackButtonHidden(true)
    }
}

struct PinMemoAddView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = PersistenceController.preview.container.viewContext
        let newPin = Pin(context: viewContext)
        
        PinContentAddView(pin: .constant(newPin), selection: .constant(0), pinName: .constant("TestPinName"), isComplete: .constant(true), selectedImages: .constant([]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(MapViewModel())
            .environmentObject(CoreDataViewModel())
    }
}
