//
//  ButtonStyles.swift
//  Moment
//
//  Created by 김민재 on 2022/06/11.
//

import SwiftUI

/*
 * 버튼 스타일
 */

struct PreviousButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 164, height: 42)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color("AddViewPurple"))
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("AddViewPurple"), lineWidth: 1)
            )
    }
}

struct NextButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 164, height: 42)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .background(Color("AddViewPurple"))
            .cornerRadius(10)
    }
}

struct ImagePickerButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(.systemGray4))
    }
}

struct ImageSelectCancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
            .background(.thinMaterial, in: Circle())
    }
}
