//
//  SelectedCategory.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/18.
//

import SwiftUI

struct SelectedCategory: View {
    
    
 
    @EnvironmentObject var cVM: CoreDataViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: false)], animation: .default) private var categories: FetchedResults<Category>
    // 지도에서 선택되어져 있는 카테고리를 카테고리 리스트에 보여주기 위한 View
    var body: some View {
        ZStack {
            Image(categories[cVM.selection].pinArray.count > 0 ? categories[cVM.selection].pinArray[0].photoArray.count > 0 ? categories[cVM.selection].pinArray[0].photoArray[0].photoName ?? "0" : "0" : "0")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(10)
            LinearGradient(colors: [.black.opacity(0.45), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Text(categories[cVM.selection].title ?? "NoNamed")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(Color(categories[cVM.selection].categoryColor ?? "default"))
                        .offset(y:6)
                    Spacer()
                }
                Text(changeDateToString(date: categories[cVM.selection].startDate ?? Date()))
                    .foregroundColor(.white)
                    .font(.system(size: 11.22))
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.leading, 24)
            .padding(.top, 25)
            
                

        }
        .frame(height: 200)
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
