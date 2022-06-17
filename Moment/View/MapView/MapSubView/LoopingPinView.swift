//
//  LoopingPinView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/13.
//

import SwiftUI

struct LoopingPinView: View {
    
    @StateObject private var timeVM = TimeViewModel()
    @State private var isUp: Bool = false
    
    var body: some View {
        Circle()
            .fill(.black.opacity(isUp ? 0.2 : 0.3))
            .blur(radius: 2)
            .frame(width: isUp ? 15 : 25, height: isUp ? 15 : 25)
            .overlay(
                Image("purplepin")
                    .resizable()
                    .frame(width: 36, height: isUp ? 44 : 38)
                    .offset(y: isUp ? -40 : -20)
            )
            .onChange(of: timeVM.timeCount) { value in
                if value % 2 != 0 {
                    withAnimation(Animation.easeOut(duration: 1).repeatForever()) {
                        isUp.toggle()
                    }
                } else {
                    withAnimation(Animation.easeIn(duration: 1).repeatForever()) {
                        isUp.toggle()
                    }
                }
            }
    }
}

struct LoopingPinView_Previews: PreviewProvider {
    static var previews: some View {
        LoopingPinView()
    }
}

final class TimeViewModel: ObservableObject {
    
    @Published var timeCount = 0
    
    var timer: Timer?
    
    init() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timeFire),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func timeFire() {
        self.timeCount += 1
    }
}
