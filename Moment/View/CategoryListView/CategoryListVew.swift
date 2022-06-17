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
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var cVM: CoreDataViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: false)], animation: .default) private var categories: FetchedResults<Category>
    
    @Namespace private var namespace
    
    @State var detailShow: Bool = false
    @State var effectID = 0
    @State var categoryAddToggle: Bool = false
    @State var selectCategory: Category?
    
    @Binding var sheetModeValue: String
    let high: CGFloat = UIScreen.main.bounds.height
    
    
    var body: some View {
        //카테고리 선택 여부 판단하여 Page 전환을 일으키는 로직
        if sm.isPinListShow {
            PinListView(selectCategory: $selectCategory, effectID: $effectID, namespace: namespace)
                .navigationBarHidden(true)
        } else {
//            NavigationView {
                ScrollView {
                    VStack {
                        Color.clear.frame(height: 100)
                        
                    
                        
                        //코어데이터로 바꿔줘야 함
                        ForEach(0..<categories.count, id: \.self) { i in
                            Button (action: {
                                withAnimation{
                                    effectID = i
                                    sm.isPinListShow = true
                                    selectCategory = categories[i]
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
                            Text("나의 Moment")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Spacer()
                            //카테고리 추가 역할
                            Button(action: {
//                                addPhoto()
                            }, label: {
                                Text("plus")
                            })
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
            Image((categories[idx].pinArray.randomElement()?.photoArray.randomElement()?.photoName ?? "0"))
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
                    Text(categories[idx].title ?? "UnNamed")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    Circle()
                        .frame(width: 6.0, height: 6.0)
                        .foregroundColor(Color(categories[idx].categoryColor ?? "default"))
                        .offset(y: 5)
                    Spacer()
                }
                Text(changeDateToString(date: categories[idx].startDate ?? Date()))
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
    
    
    
    private func addCategory() {
        let categoryTitles = [
            "제주도 여행",
            "포항 여행",
            "부산 여행",
            "서울 여행",
            "해외 여행",
            "피카츄",
            "라이츄",
            "파이리",
            "꼬부기",
            "버터풀",
            "야도란",
            "피죤투",
            "또가스",
            "서로생긴모습은 달라도",
            "우리는 모두 친구"
        ]
        let colorLists = [
            "blue",
            "brown",
            "default",
            "green",
            "mint",
            "orange",
            "pink",
            "purple",
            "red",
            "redpink",
            "yellow",
            "firstColor",
            "secondColor",
            "thirdColor",
            "fourthColor"
        ]
        for i in 0..<categoryTitles.count {
            let newCategory = Category(context: viewContext)
            newCategory.title = categoryTitles[i]
            newCategory.categoryColor = colorLists[i]
            newCategory.startDate = Date()
            newCategory.endDate = Date()
            
            PersistenceController.shared.saveContext()
        }
        
            
          
        
    }
    
    private func addPin() {
        let pinTitles = [
            "제주도 여행",
            "포항 여행",
            "부산 여행",
            "서울 여행",
            "해외 여행",
            "피카츄",
            "라이츄",
            "파이리",
            "꼬부기",
            "버터풀",
            "야도란",
            "피죤투",
            "또가스",
            "서로생긴모습은 달라도",
            "우리는 모두 친구"
        ]
        let pinEmotions = [
            "😀",
            "😇",
            "🥰",
            "🤨",
            "😎",
            "🥸",
            "☹️",
            "🥳",
            "🥺",
            "😑",
            "😪",
            "🤑",
            "🥵",
            "🫠",
            "😷"
        ]
        let pinLongitude = [
            126.941291,
            126.529304,
            126.772310,
            129.159784,
            130.123456,
            131.111111,
            130.213334,
            130.178921,
            131.123456,
            132.111111,
            132.222222,
            132.121212,
            131.123123,
            132.123123,
            130.982134
        ]
        let pinLatitude = [
            33.458327,
            33.361354,
            33.512345,
            35.158376,
            34.123456,
            34.111111,
            34.121212,
            36.121321,
            36.123123,
            35.123123,
            34.111111,
            36.999991,
            37.123123,
            33.999999,
            36.828342
            
        ]
        let pinContent = [
            "제주도 여행",
            "포항 여행",
            "부산 여행",
            "서울 여행",
            "해외 여행",
            "피카츄",
            "라이츄",
            "파이리",
            "꼬부기",
            "버터풀",
            "야도란",
            "피죤투",
            "또가스",
            "서로생긴모습은 달라도",
            "우리는 모두 친구"
        ]
        for j in 0..<pinTitles.count {
            for i in 0..<pinTitles.count {
                let newPin = Pin(context: viewContext)
                    newPin.title = pinTitles[i]
                    newPin.emotion = pinEmotions[i]
                    newPin.createdAt = Date()
                    newPin.latitude = pinLatitude[i]
                    newPin.longtitude = pinLongitude[i]
                    newPin.content = pinContent[i]
                    
                    categories[j].addToPin(newPin)
                    PersistenceController.shared.saveContext()
            }
        }
        
    }
    
    private func addPhoto() {
        let photoList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"]
        
        for i in 0..<15 {
            let pins = categories[i].pinArray
            for j in 0..<15 {
                for _ in 0..<6{
                    let newPhoto = Photo(context: viewContext)
                    newPhoto.photoName = photoList.randomElement()
                    
                    
                    newPhoto.Pin = pins[j]
                    PersistenceController.shared.saveContext()
                }
                
            }
        }
    }
}


