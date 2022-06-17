//
//  TitleImageView.swift
//  Moment
//
//  Created by 이규환 on 2022/06/11.
//

import SwiftUI

// 타이틀 이미지와 핀 제목등이 뜨는 뷰
struct TitleImageView: View {
    
    //필요한 변수들
    
    //대표사진 파일의 경로
    let sampleImage : String
    
    // 핀의 제목
    let pinTitle : String
    // 날짜
    let sampleDate : Date
    
    // 대표사진 그라디언트
    private var linearGradinet = LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
    // 날짜 변환기
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    //테스트용
    init(){
        self.sampleImage = "1"
        self.pinTitle = "전통시장"
        self.sampleDate = .now
    }
    
    var body: some View {
            
            VStack(spacing : 0){
                
                Spacer()
                // 핀 제목
                Text(pinTitle)
                    .foregroundColor(.white).bold().font(Font.system(size: 28))
                
                // 명진이의 소원
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color("default"))
                    .padding(.bottom, 8).padding(.top, 7)
                // 핀 날짜
                Text("\(sampleDate, formatter: dateFormatter)")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .font(.custom("Helvetica Neue", size: 18))
                    .padding(.bottom, 28)
                
        }
        .frame(height: 520)
        .background(Image(sampleImage)
                .resizable()
                .scaledToFill()
                .overlay(linearGradinet)
        )
    }
}

