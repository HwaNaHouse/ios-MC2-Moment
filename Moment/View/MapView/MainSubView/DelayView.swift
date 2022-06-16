//
//  DelayView.swift
//  Moment
//
//  Created by Hyeonsoo Kim on 2022/06/11.
//
//  새로운 Pin이 EmoPicker에서 생성될 때, PinView로부터 offset을 읽어오고, 그것을 기반으로 그 위에 뜨는 말풍선 Bubble형태. DelayView.
//

import SwiftUI

struct DelayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var pin: Pin
    @Binding var isRemove: Bool
    
    var body: some View {
        let width = UIScreen.main.bounds.width/10
        VStack(spacing: 16) {
            Text("핀을 추가했습니다")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black.opacity(0.8))
            HStack {
                Button {
                    deletePin()
                    isRemove = false
                } label: {
                    textEdit(text: "삭제하기", color: Color.red)
                }
                Button {
                    print()
                } label: {
                    textEdit(text: "작성하기", color: Color.defaultColor)
                }
            }
            .padding(.bottom, 10)
        }
        .padding()
        .background(
            Bubble()
                .foregroundColor(.white)
                .frame(width: width*4.4, height: width*2.7)
        )
    }
    @ViewBuilder
    private func textEdit(text: String, color: Color) -> some View {
        Capsule()
            .fill(color)
            .frame(width: 70, height: 25)
            .overlay(
                Text(text)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding(5)
                    .padding(.horizontal, 5)
            )
    }
    
    private func deletePin() {
        withAnimation {
            viewContext.delete(pin)
        }
        PersistenceController.shared.saveContext()
    }
}

struct DelayView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newPin = Pin(context: viewContext)
        return DelayView(pin: newPin, isRemove: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
