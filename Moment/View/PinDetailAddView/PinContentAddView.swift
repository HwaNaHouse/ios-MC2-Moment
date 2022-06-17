//
//  PinContentAddView.swift
//  Moment
//
//  Created by 김민재 on 2022/06/13.
//

import SwiftUI

/*
 * 컨텐츠 추가 뷰
 * 이전 단계로 : 이전 뷰로 이동
 * 핀 완료하기 : 뷰 스택 종료
 */

struct PinContentAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @State var memo: String = ""
    
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: UIScreen.main.bounds.size.height * 0.02)
            
            TextEditor(text: $memo)
                .font(.body)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
            
            Spacer()
                .frame(height: UIScreen.main.bounds.size.height * 0.05)
            
            HStack(spacing: UIScreen.main.bounds.size.width * 0.041) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("이전 단계로")
                }
                .buttonStyle(PreviousButtonStyle())
                
                Button(action: {
                    self.rootPresentationMode.wrappedValue.dismiss()
                }) {
                    Text("핀 완료하기")
                }
                .buttonStyle(NextButtonStyle())
            }
        }
        .padding(UIScreen.main.bounds.size.width * 0.059)
        .navigationBarTitle("메모 작성하기")
        .navigationBarBackButtonHidden(true)
    }
}

struct PinMemoAddView_Previews: PreviewProvider {
    static var previews: some View {
        PinContentAddView()
    }
}
