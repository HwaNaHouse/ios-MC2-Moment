//
//  CategoryListVew.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//  카테고리 리스트 뷰

import SwiftUI

struct CategoryListView: View {
    
    @EnvironmentObject var sm: StateManage
//    @EnvironmentObject var vm: CoreDataRealationshipViewModel
    
    
    
    @Namespace private var namespace
    
    @State var detailShow: Bool = false
    @State var effectID = 0
    @State var categoryAddToggle: Bool = false
    
    @Binding var sheetModeValue: String
    let high: CGFloat = UIScreen.main.bounds.height
    
    
    var body: some View {
        //카테고리 선택 여부 판단하여 Page 전환을 일으키는 로직
        if sm.isPinListShow {
            PinListView(effectID: $effectID, namespace: namespace)
                .navigationBarHidden(true)
        } else {
//            NavigationView {
                ScrollView {
                    VStack {
                        Color.clear.frame(height: 100)
                        
                    
                        
                        //코어데이터로 바꿔줘야 함
                        ForEach(0..<10, id: \.self) { i in
                            Button (action: {
                                withAnimation{
                                    effectID = i
                                    sm.isPinListShow = true
                                    
                                }
                            }, label: {
                                categoryCard(idx: i)
                                //카드 눌렀을 때 detailView 사진과 연결된 애니메이션
                                    .matchedGeometryEffect(id: i, in: namespace)
                            })
                            
                        }
                    }
//                    .background(GeometryReader {
//                        Color.clear.preference(key: ViewOffsetKey.self,
//                            value: -$0.frame(in: .named("scroll")).origin.y)
//                    })
                    
                }
                .sheet(isPresented: $categoryAddToggle) {
                    CategoryAddView(isShowCategorySheet: $categoryAddToggle)
                }
                .background{
                    Color("backgroundColor")
                }
                .navigationBarHidden(true)
                //Navbar
                .overlay(alignment: .top) {
                    VStack {
                        //명진님에 여행
                        HStack {
                            Text("명진님의 여행")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Spacer()
                            //카테고리 추가 역할
                            NavigationLink(destination: CategoryAddView(isShowCategorySheet: $categoryAddToggle)) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.black)
                                    .background{
                                        Circle()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.12), radius: 26, x: 0, y: 0)
                                    }
                            }.padding(.trailing, 10)
                            
                        }
                        .padding(.top, 30)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        }
                        .frame(height: 110)
//                        .offset(y: 50)
                        .background{
                            Color.white.frame(maxWidth: .infinity)
                        Spacer()
                    }
                    
                    
                }.ignoresSafeArea()
//            }
            
            
        }
        
    }
    
    // 카테고리 카드 컴퍼넌트
    @ViewBuilder
//    func categoryCard(category: Category) -> some View {
    func categoryCard(idx: Int) -> some View {
//        let category: Category = category
        
        ZStack {
            Image("\(idx)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120, alignment: .center)
                .cornerRadius(10)
                
                
            
//            RoundedRectangle(cornerRadius: 10)
//                .frame(width: 344, height: 100)
//                .foregroundColor(.black)
//                .opacity(0.4)
            
            LinearGradient(colors: [.black.opacity(0.4), .black.opacity(0.34),.black.opacity(0.25), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                .frame(height: 120)
                .cornerRadius(10)
            
            
            VStack(alignment: .leading) {
                HStack (spacing: 1){
                    Text("category.title ?? ")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    Circle()
                        .frame(width: 6.0, height: 6.0)
                        .foregroundColor(.mint)
                        .offset(y: 5)
                    Spacer()
                }
                Text(changeDateToString(date: Date()))
                    .foregroundColor(.white)
                    .font(.system(size: 11.22))
                    .fontWeight(.medium)
            }.padding(.leading, 24)
        }
        .shadow(color: .black.opacity(0.08), radius: 26, y: 12)
        .padding(.vertical, 8)
        .padding(.horizontal, 23)
    }
    
    func changeDateToString(date: Date) -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        result = dateFormatter.string(from: date)
        
        return result
    }
}


