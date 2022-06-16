//
//  TotalTripView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/12.
//
//  X의 Sheet부분이 대치될 곳.
//

import SwiftUI

struct TotalTripView: View {
    @State private var sheetMode: SheetMode = .low
    @Namespace var topID
    
    var body: some View {
        let height = UIScreen.main.bounds.height
        
        TNSheet(sheetMode: $sheetMode, low: height/8.8, high: height) {
            ZStack {
                Color.black //default로 있어야함...
                VStack {
                    Spacer().frame(height: sheetMode == .low ? 20 : 100)
                    //
                    
                    HStack {
                        Text("탐나의 여행")
                            .font(sheetMode == .low ? .title3 : .title).bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                EmptyView()
                                    .id(topID)
                                ForEach(0...15, id: \.self) { _ in
                                    NavigationLink {
                                        Text("hello")
                                    } label: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundColor(.gray.opacity(0.5))
                                            .frame(height: 100)
                                    }
                                }
                            }
                        }
                        .onChange(of: sheetMode) { _ in
                            if sheetMode == .low {
                                proxy.scrollTo(topID)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}

struct TotalTripView_Previews: PreviewProvider {
    static var previews: some View {
        TotalTripView()
    }
}

enum SheetMode: CaseIterable {
    case low
    case high
}

struct TNSheet<Content: View>: View {
    @GestureState private var offset: CGFloat = .zero
    @State private var grabOffset: CGFloat = .zero
    
    let low: CGFloat
    let high: CGFloat
    let content: () -> Content
    var sheetMode: Binding<SheetMode>
    
    init(sheetMode: Binding<SheetMode>, low: CGFloat, high: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.low = low
        self.high = high
        self.content = content
        self.sheetMode = sheetMode
    }
    
    var body: some View {
        let drag = DragGesture()
            .updating($offset) { dragValue, state, _ in
                if (sheetMode.wrappedValue == .high) {
                    if (calculateOffset() + dragValue.translation.height > UIScreen.main.bounds.height-high) {
                        state = dragValue.translation.height
                    }
                } else {
                    if calculateOffset() + dragValue.translation.height < UIScreen.main.bounds.height-low+20 {
                        state = dragValue.translation.height
                    }
                }
            }
            .onEnded { value in
                sheetMode.wrappedValue = nearCase(value.translation.height, speed: value.predictedEndTranslation.height)
            }
        content()
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
        switch sheetMode.wrappedValue {
        case .low:
            return UIScreen.main.bounds.height - low
        case .high:
            return UIScreen.main.bounds.height - high
        }
    }
    
    private func nearCase(_ move: CGFloat, speed: CGFloat) -> SheetMode {
        let low = UIScreen.main.bounds.height - low
        let high = UIScreen.main.bounds.height - high
        
        switch sheetMode.wrappedValue {
        case .low:
            if move < (high-low) / 2 || speed < (high-low) / 2 {
                return .high
            } else {
                return .low
            }
        case .high:
            if move > (low-high) / 2 || speed > (low-high) / 2 {
                return .low
            } else {
                return .high
            }
        }
    }
}
