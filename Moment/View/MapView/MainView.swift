//
//  MainView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//
//  앱 실행 시 보이는 초기화면의 모든 컴포넌트 집합소.
//
//  MapView, MenuView, EmoPicker, PinPageView, DelayView, MakeCategoryView 등이 있음.
//  제일 아래 TotalTripView는 X가 다룰 카테고리 전체 Sheet 부분임.
//  상단의 categories를 연결해주면 될 듯함.
//

import SwiftUI
import MapKit
import CoreData

struct MainView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @EnvironmentObject var cVM: CoreDataViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: false)], animation: .default) private var categories: FetchedResults<Category>
    
    @State private var newPin: Pin?
    @State private var currentPin: Pin?
    @State private var pinMode: Bool = true
    @State private var isActive: Bool = false
    @State private var isRemove: Bool = false
    @State private var isNavigationViewActive: Bool = false
    @State private var isShowCategorySheet: Bool = false
    @State private var offset: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        NavigationView {
            ZStack {
                //            NavigationView {
                ZStack {
                    if categories.count != 0 {
                        MapView(category: categories[cVM.selection], currentPin: $currentPin, pinMode: pinMode, isActive: isActive, offset: $offset, isRemove: $isRemove)
                    }
                    
                    VStack {
                        HStack {
                            Menu {
                                Picker(selection: $cVM.selection) {
                                    if categories.count != 0 {
                                        ForEach(0..<categories.count, id: \.self) {
                                            Text(categories[$0].unwrappedTitle)
                                        }
                                    }
                                } label: {} //If only use Picker, cannot custom label
                            } label: {
                                if categories.count != 0 {
                                    MenuView(title: categories[cVM.selection].unwrappedTitle)
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
                                }
                            }
                            .onChange(of: cVM.selection) { _ in
                                self.currentPin = nil
                                if !viewModel.isEdited {
                                    viewModel.firstPinLocation(categories[cVM.selection])
                                }
                                viewModel.isEdited = false
                            }
                            
                            Spacer()
                            
                            Button {
                                isShowCategorySheet.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
                                    )
                            }
                        }
                        .padding(30)
                        
                        Spacer()
                        
                        ZStack(alignment: .center) {
                            
                            HStack(spacing: 15) {
                                Button {
                                    viewModel.myPosition()
                                } label: {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
                                        .overlay(
                                            Image(systemName: "location.fill")
                                                .font(.title3)
                                                .foregroundColor(.black)
                                        )
                                }
                                
                                Spacer().frame(width: pinMode ? 70 : 0, height: 70)
                                
                                Button {
                                    withAnimation {
                                        pinMode.toggle()
                                    }
                                } label: {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
                                        .overlay(
                                            Image(systemName: pinMode ? "map.fill" : "map")
                                                .font(.title3)
                                                .foregroundColor(.black)
                                        )
                                }
                            }
                            if pinMode {
                                if !categories.isEmpty {
                                    EmoPicker(category: categories[cVM.selection], isActive: $isActive, newPin: $newPin, isRemove: $isRemove)
                                }
                                Button {
                                    withAnimation {
                                        isActive.toggle()
                                        isRemove = false
                                    }
                                } label: {
                                    if isActive {
                                        Circle()
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.red)
                                            .overlay(
                                                Image(systemName: "xmark")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.white)
                                            )
                                    } else {
                                        Circle()
                                            .frame(width: 71, height: 71)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
                                            .overlay(
                                                Image("redpin")
                                            )
                                    }
                                }
                                .opacity(pinMode ? 1 : 0)
                            }
                        }
                        Spacer().frame(height: UIScreen.main.bounds.height / 9.3)
                    }
                    
                    if !categories.isEmpty {
                        if currentPin != Optional(nil) {
                            if categories[cVM.selection].pinArray.contains(currentPin!) {
                                VStack {
                                    Spacer()
                                    PinPageView(pageIndex: .withIndex(categories[cVM.selection].pinArray.firstIndex(where: { pin in
                                        pin == currentPin
                                    })!), category: categories[cVM.selection], currentPin: $currentPin, isNavigationViewActive: $isNavigationViewActive)
                                    Spacer().frame(height: UIScreen.main.bounds.height / 9.9)
                                }
                            }
                        }
                    }
                    
                    if self.newPin != Optional(nil) {
                        if isRemove {
                            DelayView(pin: newPin!, isRemove: $isRemove)
                                .position(x: offset.x, y: offset.y)
                        }
                    }
                }
                .sheet(isPresented: $isShowCategorySheet) {
                    MakeCategoryView(selection: $cVM.selection, isShowCategorySheet: $isShowCategorySheet)
                }
                //                .navigationBarHidden(true)
                //            }
                //            .environment(\.rootPresentationMode, self.$isNavigationViewActive)
                
                TotalTripView() //sheet view
                //                OpeningView()
                
            }
            .navigationBarHidden(true)
        }
        .environment(\.rootPresentationMode, self.$isNavigationViewActive)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newCategory = Category(context: viewContext)
        newCategory.title = "하위"
        
        return MainView()
            .environmentObject(MapViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct MakeCategoryView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
    
    @State private var title: String = ""
    @Binding var selection: Int
    @Binding var isShowCategorySheet: Bool
    @State private var selectedColor: String = "default"
    var colors: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "pink", "brown"]
    
    
    var body: some View {
        let titleLimit = 15
        
        VStack(alignment: .leading, spacing: 50) {
            
            Text("새로운 카테고리 생성하기")
                .font(.title2).bold()
                .foregroundColor(Color.defaultColor)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("카테고리명")
                        .bold()
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("\(title.count)")
                            .font(.footnote)
                        Text("/15")
                            .font(.footnote)
                    }
                }
                
                TextField("탐나님의 \(categories.count+1)번째 여행", text: $title)
                    .frame(height: 40)
                    .padding(.all, 5)
                    .font(Font.system(size: 23, design: .rounded).bold())
                    .modifier(ClearButton(text: $title))
                    .onChange(of: title) { _ in
                        title = String(title.prefix(titleLimit))
                    }
                
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 2)
            }
            
            VStack(alignment: .leading) {
                Text("색상 선택")
                    .bold()
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Button {
                            self.selectedColor = color
                        } label: {
                            colorButton(color)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height/12)
            }
            
            Button {
                addCategory()
                isShowCategorySheet.toggle()
                self.selection = 0
            } label: {
                HStack {
                    Spacer()
                    Text("카테고리 생성")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.defaultColor))
            }
            .disabled(title.isEmpty || selectedColor == "default")
            
            Spacer()
            
        }
        .padding()
    }
    
    private func addCategory() {
        withAnimation {
            let newCategory = Category(context: viewContext)
            newCategory.title = title
            newCategory.categoryColor = selectedColor
            newCategory.startDate = Date()
            
            PersistenceController.shared.saveContext()
        }
    }
    
    @ViewBuilder
    private func colorButton(_ color: String) -> some View {
        Circle()
            .foregroundColor(Color(color).opacity(color == selectedColor ? 0.3 : 0))
            .overlay(
                Circle().frame(width: 25, height: 25)
                    .foregroundColor(Color(color))
            )
    }
}

struct ClearButton: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            
            content
                .disableAutocorrection(true) //MARK: 자동완성 없애주는 친구.
                .autocapitalization(.none) //MARK: 첫 글자 대문자 안나오게.
            
            if !text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 10)
            }
        }
    }
}
