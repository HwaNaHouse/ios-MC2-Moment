//
//  PinImageAddView.swift
//  Moment
//
//  Created by 김민재 on 2022/06/11.
//

import SwiftUI

/*
 * 사진 추가 뷰
 * 이전 단계로 : 이전 뷰로 이동
 * 다음 단계로 : PinMemoAddView로 이동
 */

struct PinImageAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var pin: Pin
    @Binding var selection: Int
    @Binding var pinName: String
    @Binding var isComplete: Bool
    
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                if selectedImages.count == 0 {
                    Spacer()
                    
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        Image("ImagePickerButton")
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 1)
                            )
                    }
                    .buttonStyle(ImagePickerButtonStyle())
                    
                    Spacer()
                }
                else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { proxy in
                            HStack {
                                ForEach(Array(self.selectedImages.enumerated()), id: \.offset) { index, image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.size.width * 0.846, height: UIScreen.main.bounds.size.width * 0.846)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .onAppear {
                                                withAnimation {
                                                    proxy.scrollTo(index, anchor: .leading)
                                                }
                                            }
                                            .id(index)
                                            .padding(UIScreen.main.bounds.size.width * 0.04)
                                        
                                        Button(action: {
                                            selectedImages.remove(at: index)
                                        }) {
                                            Image("ImageSelectCancelButton")
                                                .resizable()
                                        }
                                        .buttonStyle(ImageSelectCancelButtonStyle())
                                        .padding(UIScreen.main.bounds.size.width * 0.08)
                                    }
                                }
                                .frame(maxHeight: .infinity)
                                
                                Button(action: {
                                    self.showImagePicker.toggle()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(Font.system(size:90, weight: .ultraLight))
                                }
                                .buttonStyle(ImagePickerButtonStyle())
                            }
                        }
                    }
                }
                
                HStack(spacing: UIScreen.main.bounds.size.width * 0.041) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("이전 단계로")
                    }
                    .buttonStyle(PreviousButtonStyle())
                    
                    NavigationLink(destination: PinContentAddView(pin: $pin, selection: $selection, pinName: $pinName, isComplete: $isComplete, selectedImages: $selectedImages)) {
                        Text("다음 단계로")
                    }
                    .isDetailLink(false)
                    .buttonStyle(NextButtonStyle())
                }
                .padding(UIScreen.main.bounds.size.width * 0.059)
            }
            .fullScreenCover(isPresented : $showImagePicker){
                ImagePicker(images: $selectedImages, picker: $showImagePicker)
            }
        }
        .navigationBarTitle("사진 추가하기")
        .navigationBarBackButtonHidden(true)
    }
}

struct PinImageAddView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newPin = Pin(context: viewContext)
        
        PinImageAddView(pin: .constant(newPin), selection: .constant(0), pinName: .constant("TestPinName"), isComplete: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(MapViewModel())
            .environmentObject(CoreDataViewModel())
    }
}
