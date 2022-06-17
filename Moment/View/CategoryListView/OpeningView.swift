//
//  OpeningView.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//. 첫 앱 시작시 나왔다 사라지는 View

import SwiftUI

struct OpeningView: View {
    
    let screenHeigh = UIScreen.main.bounds.height
    @State var startToggle: [Bool] = [true, true, true, true, true]
    let colorList:[String]  = ["firstColor","secondColor","thirdColor","fourthColor","fifthColor"]
    @State var testToggle: Bool = true
    @State var opacityToggle: Bool = true
    @State var backgroundToggle: Bool = true
    
    var body: some View {
        ZStack {
            
            if backgroundToggle {
                Color.white.frame(height: screenHeigh)
            }

            HStack (spacing: 0){
                
                ForEach (0..<5) { i in
                    colorFrame(colorList[i], i: i)
                }
                
            }
            Text("MOMENT")
                .foregroundColor(.white)
                .font(.system(size: 32))
                .fontWeight(.bold)
                .opacity(testToggle ? 0 : 1)
            
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .onAppear{
            Task {
                try await startToggle()
            }
        }
        
        
    }
    
    @ViewBuilder
    func colorFrame(_ color: String, i: Int) -> some View {
        
        let color = color
        
        
        VStack(spacing: 0) {
            Color(color).frame(height: startToggle[i] ? 0 : screenHeigh)
                .opacity(opacityToggle ? 1 : 0)
            Spacer()
        }
    }
    
    func startToggle() async throws {
        for i in 0..<5 {
            try await Task.sleep(nanoseconds: UInt64(0.08 * 1_000_000_000))
            withAnimation(Animation.linear(duration: 0.4)) {
                startToggle[i].toggle()
            }
        }
        try await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
        withAnimation {
            testToggle.toggle()
        }
        
        try await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000))
        withAnimation {
            testToggle.toggle()
        }
            
        withAnimation {
            opacityToggle.toggle()
            backgroundToggle.toggle()
        }
        
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView()
    }
}
