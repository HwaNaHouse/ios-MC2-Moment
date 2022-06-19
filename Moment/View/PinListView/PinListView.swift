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
    
    @State private var isNavigationViewActive: Bool = false
    
    @EnvironmentObject var sm: StateManage
    
    @Binding var effectID: Int
    let namespace: Namespace.ID
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: 70)
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        Color.clear.frame(height: 68)
                        
                        VStack {
                            HStack {
                                Text("Korea Travel")
                                    .foregroundColor(.white)
                                    .font(.system(size:22))
                                    .fontWeight(.bold)
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 8, height: 8)
                                    .offset(y: 5)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 23)
                            .padding(.top, 5)
                            .opacity(1)
                            HStack {
                                Text("2020.05.14")
                                    .foregroundColor(.white)
                                    .font(.system(size:14))
                                    .fontWeight(.regular)
                                Spacer()
                            }
                            .padding(.horizontal, 23)
                            
                        }
                        
                        
                        Color.clear.frame(height: 10)
                            .padding(.bottom, 10)
                        //코어데이터로 For문 돌려 카드 컴퍼넌트에 스테이트 바인딩 해주기
                        ForEach(0..<10) { i in
                            PinCardView()
                                .onTapGesture {
                                    sm.isDetailShow.toggle()
                                }
                            
                        }
                    }
                    .fullScreenCover(isPresented: $sm.isDetailShow, content: {
                        PinDetailView()
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
                                title = "KoreaTravel"
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
                    VStack(spacing: 0) {
                        Image("1")
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
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
