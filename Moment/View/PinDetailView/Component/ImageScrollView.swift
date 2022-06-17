//
//  ImageScrollView.swift
//  PinDetailView_test
//
//  Created by 이규환 on 2022/06/12.
//

import SwiftUI

//이미지가 스크롤되는 뷰
struct ImageScrollView: View {
    // 사진 크게보기를 위한 바인딩 값
    
    //SamllImageView - Bool Value
    @Binding var isActivated : Bool
    
    //클릭 시 클릭 사진을 보여주기 위한 인덱스값
    @Binding var indexValue : Int
    
    //이미지 파일 경로가 들어가있는 리스트
    @Binding var imageList : Pin?
    
    var body: some View {
        
        // imageList가 빈값이면 뷰를 안보여줌
        if let data = imageList {
            //Layout
            VStack(spacing : 0){
            Spacer().frame(height: 22)
            Text("여행 사진")
                    .foregroundColor(Color("default"))
                    .font(Font.system(size: 20))
                    .bold()
                .padding(.bottom, 20)
                
            //Image Scroll
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing : 0){
                    Spacer().frame(width: 41.5)
                    //
                    ForEach(0..<data.photoArray.count){ i in
                    Button {
                            indexValue = i
                            isActivated.toggle()
                    }label: {
                        Image(data.photoArray[i].photoName ?? "0")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)
                            }
                            .padding(.bottom,20).padding(.trailing,  19)
                        }
                    }
                }
            
                Spacer().frame(height: 10)
                
            }
            .background(.white)
            .shadow(color: .black.opacity(0.08), radius: 26, y: 12)
            
        }
    }
}


