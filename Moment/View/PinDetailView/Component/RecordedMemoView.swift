//
//  RecordedMemoView.swift
//  Moment
//
//  Created by 이규환 on 2022/06/12.
//
//지오메트리를 이용해서 글자수의 따른 백그라운드의 크기가 조절 가능하게 설정하였습니다. # 여백을 위해


import SwiftUI
// 기록된 내용을 보여주는 뷰
struct RecordedMemoView: View {
    
    // 기록 내용
    @Binding public var selectedPin : Pin?
    
    var body: some View {
        
        // 내용이 없다면 뷰가 안뜸
        if let content = selectedPin?.content {
            
            ZStack{
                
                Color.white
                
                
                VStack(spacing: 0){
                    Text("여행 메모")
                        .foregroundColor(Color("default"))
                        .bold()
                        .font(Font.system(size: 20))
                        .padding(.bottom, 40)
                    
                    // 기록한 내용 표시 구역
                    Text(content)
                        .lineSpacing(2)
                        .font(Font.system(size: 14))
                        .frame(width: 305, alignment: .center)
                        .background(
                            
                            //GeometryReader로 해당 뷰의 사이즈를 추출 또는 변수 저장해서 활용
                            GeometryReader { proxy in
                                
                            Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                                
                            // 미적용 시 글자와 사각형 사이의 여백이 없어짐
                            .frame(width: 344, height: proxy.size.height + 42)
                                
                            // 미적용 시 사각형의 위치가 달라짐. 사각형의 원점이 좌측상단으로 만들어지기 때문
                            .position(x : proxy.size.width / 2, y: proxy.size.height / 2)
                                
                            // 뒷배경과의 차이를 위해 그림자효과 적용
                            .shadow(color: .black.opacity(0.08), radius: 26, y: 12)
                        })
                }
            }
        }
    }
}
