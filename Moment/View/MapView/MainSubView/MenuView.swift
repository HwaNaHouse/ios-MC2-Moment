//
//  PickerTest.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/12.
//
//  MainView 상단의 카테고리를 선택하는 Menu창.
//

import SwiftUI

struct MenuView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.black)
            Spacer()
            Image(systemName: "chevron.down")
                .font(.callout.bold())
                .layoutPriority(1)
            
        }
        .foregroundColor(.defaultColor)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 44)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.white)
        )
    }
}

struct PickerTest_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(title: "탐나의 여행")
    }
}
