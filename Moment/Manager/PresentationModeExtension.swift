//
//  RootPresentationModeExtension.swift
//  Moment
//
//  Created by 김민재 on 2022/06/11.
//
import SwiftUI

/*
 * 환경변수 설정
 * Source : https://github.com/Whiffer/SwiftUI-PopToRootExample
 */

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
    public mutating func dismiss() {
        self.toggle()
    }
}

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}
