//
//  ViewOffsetKey.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//

// PinListview에서 스크롤 value를 얻기 위한 로직
// https://stackoverflow.com/questions/62588015/get-the-current-scroll-position-of-a-swiftui-scrollview

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
