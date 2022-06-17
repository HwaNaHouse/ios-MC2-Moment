//
//  PinDrawStyle.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/08.
//
//  PurplePin은 맵에 찍히는 핀들의 백그라운드를 채우는 그림이다.
//  Bubble은 DelayView의 백그라운드를 채우는 그림이다.
//

import SwiftUI
import MapKit

struct PurplePin: View {
    var color: Color
    var body: some View {
        PurplePinDraw()
            .fill(
                color
            )
            .frame(width: 36, height: 45)
    }
}

struct PurplePinDraw: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0.40909*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: width, y: 0.72727*height), control2: CGPoint(x: 0.5*width, y: height))
        path.addCurve(to: CGPoint(x: 0, y: 0.40909*height), control1: CGPoint(x: 0.5*width, y: height), control2: CGPoint(x: 0, y: 0.72727*height))
        path.addCurve(to: CGPoint(x: 0.14645*width, y: 0.11982*height), control1: CGPoint(x: 0, y: 0.30059*height), control2: CGPoint(x: 0.05268*width, y: 0.19654*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0.24021*width, y: 0.0431*height), control2: CGPoint(x: 0.36739*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.85355*width, y: 0.11982*height), control1: CGPoint(x: 0.63261*width, y: 0), control2: CGPoint(x: 0.75979*width, y: 0.0431*height))
        path.addCurve(to: CGPoint(x: width, y: 0.40909*height), control1: CGPoint(x: 0.94732*width, y: 0.19654*height), control2: CGPoint(x: width, y: 0.30059*height))
        path.closeSubpath()
        return path
    }
}

struct Bubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.17442*height))
        path.addCurve(to: CGPoint(x: 0.1*width, y: 0), control1: CGPoint(x: 0, y: 0.07809*height), control2: CGPoint(x: 0.04477*width, y: 0))
        path.addLine(to: CGPoint(x: 0.9*width, y: 0))
        path.addCurve(to: CGPoint(x: width, y: 0.17442*height), control1: CGPoint(x: 0.95523*width, y: 0), control2: CGPoint(x: width, y: 0.07809*height))
        path.addLine(to: CGPoint(x: width, y: 0.68605*height))
        path.addCurve(to: CGPoint(x: 0.9*width, y: 0.86047*height), control1: CGPoint(x: width, y: 0.78238*height), control2: CGPoint(x: 0.95523*width, y: 0.86047*height))
        path.addLine(to: CGPoint(x: 0.53667*width, y: 0.86047*height))
        path.addLine(to: CGPoint(x: 0.49333*width, y: 0.99419*height))
        path.addLine(to: CGPoint(x: 0.45*width, y: 0.86047*height))
        path.addLine(to: CGPoint(x: 0.1*width, y: 0.86047*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.68605*height), control1: CGPoint(x: 0.04477*width, y: 0.86047*height), control2: CGPoint(x: 0, y: 0.78238*height))
        path.addLine(to: CGPoint(x: 0, y: 0.17442*height))
        path.closeSubpath()
        return path
    }
}
