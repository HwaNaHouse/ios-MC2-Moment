//
//  EmotionView.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/17.
//

import SwiftUI



//테두리 있는 이모티콘
//기본 default size, imageName, color 설정해 두고 값 없을 때 나오는것도 구현 가능
struct EmotionView: View {
    
    @State var width: Double = 21.50
    @State var height: Double = 21.50
    @State var emotionName: String = "1"
    @State var color: String = "red"
    
    var body: some View {
        Image(emotionName)
            .resizable()
            .frame(width: self.width, height: self.height)
            .background{
                Circle()
                    .frame(width: self.width + 6.5, height: self.height + 6.5)
                    .foregroundColor(Color(color))
            }
    }
}

struct EmotionView_Previews: PreviewProvider {
    
    @State var width: Double = 23
    @State var height: Double = 23
    @State var emotionName: String = "1"
    @State var color: String = "yellow"
    
    
    static var previews: some View {
        EmotionView()
    }
}
