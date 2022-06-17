//
//  CategoryAddView.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//

import SwiftUI

struct CategoryAddView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
    
    @State private var title: String = ""
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
//                addCategory()
                isShowCategorySheet.toggle()
                
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
