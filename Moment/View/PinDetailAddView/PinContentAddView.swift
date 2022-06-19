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
    @Environment(\.managedObjectContext) private var viewContext
    
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
                    let photoSaveTime = Date()
                    for i in 0 ..< selectedImages.count {
                        let photoCoreData = Photo(context: viewContext)
                        photoCoreData.photoName = "\(photoSaveTime.timeIntervalSince1970)_\(String(i)).png"
                        pin.addToPhoto(photoCoreData)
                    }
                    DispatchQueue.main.async {
                        for (i, photo) in self.selectedImages.enumerated() {
                            _ = UIImageFileManager.shared.saveImage(image: photo, path: "photo", fileName: "\(photoSaveTime.timeIntervalSince1970)_\(String(i)).png")
                        }
                    }
                    pin.title = self.pinName.count == 0 ? nil : self.pinName
                    pin.content = self.pinContent.count == 0 ? nil : self.pinContent
                    cVM.selection = self.selection
                    viewModel.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.pin.latitude, longitude: self.pin.longtitude), span: MapDetails.defaultSpan)
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
