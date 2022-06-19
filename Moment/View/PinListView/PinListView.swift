//
//  PinListView.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
// 핀리스트 보여주는 곳


import SwiftUI

struct PinListView: View {
    
    @State var isTitleToggle: Bool = false
    @State var isPinListShow: Bool = true
    @State var title: String = ""
    @State var isOffset:CGFloat = .zero
    
    
    @EnvironmentObject var sm: StateManage
    
    @Binding var selectCategory: Category?
    @State var selectPin: Pin?
    
    @Binding var effectID: Int
    
    @Binding var selectedIndex: Int
    
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 70)
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    Color.clear.frame(height: 68)
                    
                    VStack {
                        HStack {
                            Text(selectCategory?.title ?? "UnNamed")
                                .foregroundColor(.white)
                                .font(.system(size:22))
                                .fontWeight(.bold)
                            Circle()
                                .foregroundColor(Color(selectCategory?.categoryColor ?? "black"))
                                .frame(width: 8, height: 8)
                                .offset(y: 5)
                                
                            Spacer()
                        }
                        .padding(.horizontal, 23)
                        .padding(.top, 5)
                        .opacity(1)
                        HStack {
                            Text(changeDateToString(date: selectCategory?.startDate ?? Date()))
                                .foregroundColor(.white)
                                .font(.system(size:14))
                                .fontWeight(.regular)
                            Spacer()
                        }
                        .padding(.horizontal, 23)
                        
                    }
                    
                        
                    Color.clear.frame(height: 10)
                        .padding(.bottom, 10)
                    //선택되어진 카테고리내 핀 리스트를 생성
                    if let data = selectCategory {
                        if let pins = data.pinArray {
                            ForEach(0..<(selectCategory!.pinArray.count), id: \.self) { i in
                                PinCardView(pin: pins[i], selectedCategory: $selectCategory, selectedIndex: $selectedIndex)
                                    .onTapGesture {
                                        sm.isDetailShow.toggle()
                                        selectPin = pins[i]
                                    }
                                
                            }
                        }
                        
                    }
                    
                }
                .fullScreenCover(isPresented: $sm.isDetailShow, content: {
                    PinDetailView(selectPin: $selectPin)
                })
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y)
                })
                // 스크롤 값 변화에 따른 연산
                .onPreferenceChange(ViewOffsetKey.self) {
                    isOffset = $0
                    if $0 > 95 {
                        withAnimation {
                            isTitleToggle = true
                            title = selectCategory?.title ?? "UnNamed"
                        }
                    } else {
                        withAnimation{
                            isTitleToggle = false
                        }
                    }
                    if $0 < -150 {
                        withAnimation {
                            sm.isPinListShow = false
                        }
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            
        
        }
        .overlay{
            PinNavbar(isTitleToggle: $isTitleToggle, title: $title)
        }
        //일반적인 배경화면
        .background {
            ZStack {
                let pinArrayCount = selectCategory?.pinArray.count ?? 0
                
                
                VStack(spacing: 0) {
                    Image(pinArrayCount > 0 ? (selectCategory?.pinArray[0].photoArray.count ?? 0 > 0 ? selectCategory?.pinArray[0].photoArray[0].photoName ?? "0" : "0" ): "0")
                        .resizable()
                        .frame(height: 333)
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: effectID, in: namespace)
                    Color.clear
                }
                ZStack {
                    VStack(spacing: 0) {
                        Color.white.opacity(0.30)
                        Color.clear.opacity(0.5)
                            .frame(height: 50)
                    }
                    VStack(spacing: 0) {
                        Color.clear
                        Color.white.opacity(0.30)
                            .frame(height: 100)
                    }
                    .offset(y: 50)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .offset(y: -50)
            
        }
        
        .edgesIgnoringSafeArea(.all)
//        .navigationBarHidden(false)
    }
    func changeDateToString(date: Date) -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        result = dateFormatter.string(from: date)
        
        return result
    }
}
