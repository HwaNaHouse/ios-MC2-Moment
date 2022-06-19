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
    @State var selectedIndex: Int = 0
    
    @Binding var sheetModeValue: String
    let high: CGFloat = UIScreen.main.bounds.height
    
    @State var isOffset: CGFloat = .zero
    @State var isNavbarOffset: CGFloat = .zero
    
    
    var body: some View {
        //카테고리 선택 여부 판단하여 Page 전환을 일으키는 로직
        if sm.isPinListShow {
            PinListView(selectCategory: $selectCategory, effectID: $effectID, selectedIndex: $selectedIndex ,namespace: namespace)
                .navigationBarHidden(true)
        } else {
//            NavigationView {
                ScrollView {
                    VStack {
                        
                        //Safetyarea와 Navbar 영역을 보완
                        Color.clear.frame(height: sm.sheetModeValue == "low" ? 50 : 110 )
                        
                        //맵에서 선택되어져 있는 여행 영역
                        Button (action: {
                            withAnimation {
                                effectID = categories.count
                                sm.isPinListShow = true
                                selectCategory = categories[cVM.selection]
                                
                            }
                            
                        }, label: {
                            SelectedCategory()
                                .matchedGeometryEffect(id: categories.count, in: namespace)
                        })
                        
                        
                        
                        HStack {
                            Text("모든 여행")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                
                            Spacer()
                        }
                        .padding(.leading, 23)
                        .padding(.bottom, 19)
                        .padding(.top, 33)
                        
                        
                        //코어데이터에 카테고리 리스트의 수만큼 카드 컴퍼넌트 생성
                        ForEach(0..<categories.count, id: \.self) { i in
                            Button (action: {
                                withAnimation{
                                    //이펙트를 위한 키 넘버
                                    effectID = i
                                    //핀리스트 페이지로 전환하기 위한 토글
                                    sm.isPinListShow = true
                                    //선택된 selectCategory의 대한 정보를 준다
                                    selectCategory = categories[i]
                                    selectedIndex = i
                                }
                            }, label: {
                                categoryCard(idx: i)
                                //카드 눌렀을 때 detailView 사진과 연결된 애니메이션
                                    .matchedGeometryEffect(id: i, in: namespace)
                            })
                            
                        }
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    // 스크롤 값 변화에 따른 연산
                    .onPreferenceChange(ViewOffsetKey.self) {
                        isOffset = $0
                        if sm.sheetModeValue == "high" && (isOffset - isNavbarOffset) < -140 {
                            withAnimation {
                                sm.sheetModeValue = "low"
                            }
                            
                        }
                    }
                    
                }
                .coordinateSpace(name: "scroll")
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
                        //Category Sheet 상단 네브바 역할
                        HStack {
                            Text("나의 Moment")
                                .font(.system(size: sm.sheetModeValue == "low" ? 20 : 24))
                                .fontWeight(.bold)
                            Spacer()
                            //카테고리 추가 역할
//                            Button(action: {
//                                cVM.
//                            }, label: {
//                                Text("cccccc")
//                            })
//                            Button(action: {
//                                addPin()
//                            }, label: {
//                                Text("pppppppp")
//                            })
//                            Button(action: {
//                                print(categories[1].photoArray.count, "< photoArray")
//                                print(categories[1].pinArray.count, "< pinArray")
//                                print(categories[1].pinArray[0].photoArray.count, "< photo in pinArray")
//                            }, label: {
//                                Text("phdddd")
//                            })
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
                        //TNSheet가 low에 있을 때 offset을 통해 위치를 조정해 준다
                        .offset(y: sm.sheetModeValue == "low" ? -20 : 0)
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named("navbar")).origin.y)
                        })
                        // 스크롤 값 변화에 따른 연산
                        .onPreferenceChange(ViewOffsetKey.self) {
                            isNavbarOffset = $0
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 21)
                        .padding(.bottom, 4)
                        }
                        .coordinateSpace(name: "navbar")
                        //TNSheet가 low에 있을 때 offset을 통해 크기를 조정해 준다
                        .frame(height: sm.sheetModeValue == "low" ? 50 : 110)
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
        let category: Category = categories[idx]
        let pinArrayCount = categories[idx].pinArray.count
        ZStack {
            Image( pinArrayCount > 0 ?  category.pinArray[0].photoArray.count > 0 ? category.pinArray[0].photoArray[0].photoName ?? "0" : "0" : "0")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120, alignment: .center)
                .cornerRadius(10)

            
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
    //Date to String
    func changeDateToString(date: Date) -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        result = dateFormatter.string(from: date)
        
        return result
    }
    
    private func addCategory() {
        let categoryTitles = [
            "나의 뉴욕 Moment",
            "나의 캐나다 Moment",
            "나의 로키 Moment"
        ]
        let colorLists = [
            "blue",
            "orange",
            "green",
            "mint",
            "default",
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
    // 가데이터를 넣기 위한 로직
    private func addPin() {
        let pinNewyork = [
                ["Time Square","40.7579906","-73.9942974"],
                ["New York Central Park","40.772824","-73.9921798"],
                ["Statue of Liberty","40.6892653","-74.0532552"],
                ["washington square park","40.7308997","-74.0060868"],
                ["New york highline","40.7480084","-74.0135197"],
                ["Chelsea Market","40.7424668","-74.0147129"],
                ["Empire state building","40.7484564","-73.9944192"],
                ["Brooklyn bridge","40.7058253","-74.0047283"],
                ["Brooklyn","40.6454265","-74.2251825"],
                ["New York Wall street","40.706052","-74.0175804"]
            ]
//        let pinCanada = [
//                ["the Thousand Islands","44.3782231","-75.9416069"],
//                ["Toronto Downtown","43.6548609","-79.4492072"],
//                ["Niagara Falls","43.0540926","-79.3682183"],
//                ["Old Montreal","45.5069953","-73.5704748"],
//                ["Mont Royal","45.5086658","-73.6101339"],
//                ["Mont-Tremblant","46.2123668","-74.5890511"]
//            ]
//        let pinBanff = [
//            ["Johnston canyon","51.2455293","-115.8398977"],
//            ["Wate Valley","51.5037517","-114.6457144"],
//            ["Yoho National Park","51.4666797","-116.5920881"],
//            ["Banff","51.1773697","-115.6379616"],
//            ["Banff National Park","51.4968594","-115.936811"],
//            ["Columbia Icefield","52.1904628","-117.3234549"],
//            ["Lake Louise","51.4253705","-116.1772552"]
//        ]
        let pinEmotions = [
            "love",
            "sad",
            "smile",
            "soso",
            "love",
            "sad",
            "smile",
            "soso",
            "love",
            "sad",
            "smile",
            "soso",
            "love",
            "sad",
            "smile",
        ]
        let photoList = [5, 7, 5, 8, 6, 8, 6, 6, 7, 7]
        
        
        for j in 0..<pinNewyork.count {
            let newPin = Pin(context: viewContext)
                newPin.title = pinNewyork[j][0]
                newPin.emotion = pinEmotions[j]
                newPin.createdAt = Date()
                newPin.latitude = Double(pinNewyork[j][1]) ?? 36.123123
                newPin.longtitude = Double(pinNewyork[j][2]) ?? 126.123123
                newPin.content = """
                    Join developers worldwide from June 6 to 10 for an inspiring week of technology and community. Get a first look at Apple’s latest platforms and technologies in sessions, explore the newest tools and tips, and connect with Apple experts in labs and digital lounges. All online and at no cost.
                        Experience WWDC here and in the Apple Developer app.
            """
                categories[j].addToPin(newPin)
            for i in 0..<photoList[j] {
                let newPhoto = Photo(context: viewContext)
                newPhoto.photoName = "\(pinNewyork[j][0])_\(i)"
                newPin.addToPhoto(newPhoto)
                
            }
                PersistenceController.shared.saveContext()
        
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
                    
                    
                    categories[i].addToPhoto(newPhoto)
                    pins[j].addToPhoto(newPhoto)
//                    print(categories[j].photoArray[0].photoName)
                    
                    PersistenceController.shared.saveContext()
                }
                
            }
        }
    }
}


