//
//  PinDetailAddView.swift
//  Moment
//
//  Created by 김민재 on 2022/06/11.
//

import SwiftUI

/*
 * 핀 정보 설정 뷰
 * 취소하기 : 뷰 종료
 * 다음 단계로 : PinDetailAddView로 이동
 */

struct PinDetailAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: false)], animation: .default) private var categories: FetchedResults<Category>
    
    @State var pin: Pin
    @State var selection: Int
    @State var pinName = ""
    @Binding var isComplete: Bool
    
    @State private var isShow: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: UIScreen.main.bounds.size.height * 0.258)
                
                Group {
                    Section("핀 제목") {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                TextField(pin.title ?? "장소의 이름을 입력해주세요", text: $pinName)
                                    .submitLabel(.done)
                                    .font(.system(size: 20, weight: .medium))
                            }
                            .padding([.leading, .trailing], UIScreen.main.bounds.size.width * 0.044)
                            
                        }
                        .frame(height: 45)
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 30,maxHeight: 35, alignment: .leading)
                    
                    Spacer()
                        .frame(maxHeight: UIScreen.main.bounds.size.height * 0.028)
                    
                    Section("카테고리 선택") {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                                .foregroundColor(.white)
                            Menu {
                                Picker("여행 카테고리를 선택해주세요", selection: $selection) {
                                    ForEach(0..<categories.count, id: \.self) {
                                        Text(categories[$0].unwrappedTitle)
                                    }
                                }
                            }label: {
                                if categories.count != 0 {
                                    HStack {
                                        Text(categories[selection].unwrappedTitle)
                                            .font(.system(size: 20, weight: .heavy))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                    }
                                    .foregroundColor(Color("AddViewPurple"))
                                }
                            }
                            .padding([.leading, .trailing], UIScreen.main.bounds.size.width * 0.044)
                        }
                        .frame(height: 45)
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 30,maxHeight: 35, alignment: .leading)
                    
                    Spacer()
                        .frame(maxHeight: UIScreen.main.bounds.size.height * 0.028)
                    
                    Section("날짜 조정하기") {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                                .foregroundColor(.white)
                            
                            DatePicker(selection: $pin.createdAt, in: ...Date()) {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            .environment(\.locale, Locale.init(identifier: String(Locale.preferredLanguages[0].prefix(2))))
                            .padding([.leading, .trailing], UIScreen.main.bounds.size.width * 0.044)
                        }
                        .frame(height: 45)
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 30,maxHeight: 35, alignment: .leading)
                    
                    Spacer()
                    
                    HStack(spacing: UIScreen.main.bounds.size.width * 0.041) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("취소하기")
                        }
                        .buttonStyle(PreviousButtonStyle())
                        
                        NavigationLink(destination: PinImageAddView(pin: $pin, selection: $selection, pinName: $pinName, isComplete: $isComplete)) {
                            Text("다음 단계로")
                        }
                        .isDetailLink(false)
                        .buttonStyle(NextButtonStyle())
                    }
                }
                
            }
            .padding(UIScreen.main.bounds.size.width * 0.059)
            
            VStack {
                Spacer()
                    .frame(height: isShow ? 0 : UIScreen.main.bounds.size.height * 0.033)
                
                ZStack {
                    EditMapView(pin: $pin, color: categories[selection].unwrappedCategoryColor, isShow: $isShow)
                        .cornerRadius(10)
                        .frame(maxWidth: isShow ? .infinity : UIScreen.main.bounds.size.width * 0.882, maxHeight: isShow ? .infinity : UIScreen.main.bounds.size.height * 0.178)
                    if !isShow {
                        Color.white.opacity(0.1)
                            .frame(maxHeight: UIScreen.main.bounds.size.height * 0.178)
                            .onTapGesture {
                                if !isShow {
                                    withAnimation {
                                        isShow.toggle()
                                    }
                                }
                            }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
                    .frame(maxHeight: isShow ? 0 : .infinity)
            }
        }
        .navigationBarTitle("핀 완성하기")
        .navigationBarBackButtonHidden(true)
    }
}

struct PinDetailAddView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newPin = Pin(context: viewContext)
        
        PinDetailAddView(pin: newPin, selection: 0, isComplete: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(MapViewModel())
            .environmentObject(CoreDataViewModel())
    }
}
