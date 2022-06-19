//
//  TotalTripView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/12.
//
//  X의 Sheet부분이 대치될 곳.
//  TNSheet 부분

import SwiftUI

struct TotalTripView: View {
    
    @EnvironmentObject var sm: StateManage
    
    @GestureState private var offset: CGFloat = .zero
    @State private var grabOffset: CGFloat = .zero
    
    let low: CGFloat = UIScreen.main.bounds.height / 8.8
    let high: CGFloat = UIScreen.main.bounds.height
    @State var sheetMode: String = "low"
    
    @State var isTitleToggle: Bool = false
    @State var isPinListShow: Bool = true
    @State var title: String = ""
    @State var isOffset:CGFloat = .zero
    
    
    @State var effectID = 0
    
    
    var body: some View {
        
        let drag = DragGesture()
            .updating($offset) { dragValue, state, _ in
                if (sm.sheetModeValue == "high") {
                    if (calculateOffset() + dragValue.translation.height > UIScreen.main.bounds.height-high) && !sm.isPinListShow {
                        state = dragValue.translation.height
                    }
                } else {
                    if calculateOffset() + dragValue.translation.height < UIScreen.main.bounds.height-low+20 {
                        state = dragValue.translation.height
                    }
                }
            }
            .onEnded { value in
                // PinList를 보고 있는 상태에선 드래그하여 창을 내릴 수 없게 만든다.
                if !sm.isPinListShow{
                    sm.sheetModeValue = nearCase(value.translation.height, speed: value.predictedEndTranslation.height)
                }
                
            }
        
        ZStack {
            Color.white
            VStack {
                //시트가 드래그 되어 상단에 위치를 하게 되면 ignoreSafetyArea처럼 보이게 하기 위해 프레임으로 영역을 채운다
                Spacer().frame(height: sm.sheetModeValue == "low" ? 20: 50)
                
                //탐나 시트 내부에 CategoryListView
                CategoryListView(sheetModeValue: $sheetMode)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
        .offset(y: offset) //motion시각화 & case변환하는 용도(일회성)
        .gesture(drag)
        .animation(Animation.easeInOut(duration: 0.3), value: offset)
        .offset(y: calculateOffset()) //실제 offset(고정값)
        .animation(Animation.easeInOut(duration: 0.3), value: calculateOffset())
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: -1)
        .overlay(
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .overlay(
                        GeometryReader { geome -> Color in
                            let offset = geome.frame(in: .global).minY
                            DispatchQueue.main.async {
                                self.grabOffset = offset
                            }
                            return Color.clear
                        }
                    )
                    .offset(y: 10)
                    .frame(width: 50, height: 5)
                    .opacity(sm.isPinListShow ? 0 : 1) // PinListView가 열리면 상단 라인을 가려준다
                    .foregroundColor(.secondary)
                    .offset(y: offset)
                    .gesture(drag)
                    .animation(Animation.easeInOut(duration: 0.3), value: offset)
                    .offset(y: max(calculateOffset(), 60))
                    .animation(Animation.easeInOut(duration: 0.3), value: calculateOffset())
                Spacer()
            }
        )
        .edgesIgnoringSafeArea(.all)
        .background(0.5 - 0.001*grabOffset <= 0 ? .clear : .black.opacity(0.5 - 0.001*grabOffset))
    }
    
    private func calculateOffset() -> CGFloat {
        
        if sm.sheetModeValue == "low" {
            return UIScreen.main.bounds.height - low
        }
        else {
            return UIScreen.main.bounds.height - high
        }
    }

    private func nearCase(_ move: CGFloat, speed: CGFloat) -> String {
        let low = UIScreen.main.bounds.height - low
        let high = UIScreen.main.bounds.height - high
        
        if sm.sheetModeValue == "low" {
            if move < (high-low) / 2 || speed < (high-low) / 2 {
                return "high"
            } else {
                return "low"
            }
        }
        else {
            if move > (low-high) / 2 || speed > (low-high) / 2 {
                return "low"
            } else {
                return "high"
            }
        }
        
    }
}


//struct TNSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        TNSheet()
//    }
//}
//struct TotalTripView_Preview: PreviewProvider {
//    static var previews: some View {
//        TotalTripView()
//    }
//}
