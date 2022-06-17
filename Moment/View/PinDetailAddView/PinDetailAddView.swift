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
    @State private var pinDate = Date()
    @State var selectedCategory = "카테고리"
    @State var pinName = ""
    var categoryList = ["뉴욕 여행", "전국 일주", "동남아 여행"]
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.main.bounds.size.height * 0.033)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: UIScreen.main.bounds.size.height * 0.178)
                .foregroundColor(.gray)
            
            Spacer()
                .frame(maxHeight: UIScreen.main.bounds.size.height * 0.047)
            
            Section("카테고리 선택") {                ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
                    .foregroundColor(.white)
                
                Menu {
                    Picker("여행 카테고리를 선택해주세요", selection: $selectedCategory) {
                        ForEach(categoryList, id: \.self) {
                            Text($0)
                        }
                    }
                }label: {
                    HStack {
                        Text(selectedCategory)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .foregroundColor(Color("AddViewPurple"))
                }
                .padding([.leading, .trailing], UIScreen.main.bounds.size.width * 0.044)
            }
            .frame(height: 45)
            }
            .font(.system(size: 18, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 30,maxHeight: 35, alignment: .leading)
            
            Spacer()
                .frame(maxHeight: UIScreen.main.bounds.size.height * 0.028)
            
            Section("위치 추가하기") {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width: 25, height: 25)
                        TextField("장소의 이름을 입력해주세요", text: $pinName)
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
            
            Section("날짜 조정하기") {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                        .foregroundColor(.white)
                    
                    DatePicker(selection: $pinDate, in: ...Date()) {
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
                
                NavigationLink(destination: PinImageAddView()) {
                    Text("다음 단계로")
                }
                .isDetailLink(false)
                .buttonStyle(NextButtonStyle())
            }
        }
        .padding(UIScreen.main.bounds.size.width * 0.059)
        .navigationBarTitle("핀 완성하기")
        .navigationBarBackButtonHidden(true)
    }
}

struct PinDetailAddView_Previews: PreviewProvider {
    static var previews: some View {
        PinDetailAddView()
    }
}
