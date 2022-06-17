//
//  StateManager.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//  보여주고 있는 View에 State 관리를 해주는 ViewModel

import SwiftUI

class StateManage: ObservableObject {
    @Published var sheetModeValue: String
    @Published var sheetHeightValue: CGFloat
    @Published var canScroll: Bool
    
    @Published var isPinListShow: Bool
    @Published var isPinNavbarTitleShow: Bool
    
    init() {
        self.sheetModeValue = "low"
        self.sheetHeightValue = UIScreen.main.bounds.height
        
        self.isPinListShow = false
        self.isPinNavbarTitleShow = false
        self.canScroll = false
        
    }
    
    func makeHigh() async throws {
        try await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        canScroll.toggle()
    }
}
