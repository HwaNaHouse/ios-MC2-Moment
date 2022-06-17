//
//  ImageDetailView.swift
//  Moment
//
//  Created by 이규환 on 2022/06/15.
//

import SwiftUI


// 사진을 클릭하면 뜨는 디테일 뷰

// TapView를 위한 identifiable하게 형성된 image 객체
struct Images : Identifiable {
    
    var id = UUID().uuidString
    var imagePath : String
    
}

struct ImageDetailView : View {
    //Binding
        // close or open ShowImageView
    @Binding var isActivatedShowImageView : Bool
        // 클릭된 사진의 id값을 얻기 위해 사용됨.
    @Binding var indexValue  : Int
        // 받아오는 수정 전 이미지 리스트
    @Binding var originImageList :  [String]
    
    //State
        // 수정 후 이미지 리스트
    @State var changedImagesList : [Images] = []
        // 각 이미지들의 uuidstring이 될 값
    @State var currentPost : String = ""
        // 확대 변수
    @State var imageScale : CGFloat = 1
        // tap시 상하 tapitem용 변수
    @State var tapGesture = false
    
    var body: some View {
        
        TabView(selection: $currentPost) {

            ForEach(changedImagesList) { image in
                
                        VStack {
                            Spacer()
                            Image(image.imagePath)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(0)
                            //확대 제스처
                            .scaleEffect(imageScale)
                            .gesture(MagnificationGesture().onChanged({ (value) in
                                imageScale = value
                            }).onEnded({ (_) in
                                withAnimation(.spring()){
                                    imageScale = 1
                                }
                            }))
                            // 여기까지
                            Spacer()
                        }.padding(.horizontal, 5)
                        // 이미지에 태그
                        .tag(image.id)
                        }
                    }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
        
                .overlay(
                    VStack{
                        HStack(spacing: 0){
                            Circle()
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .frame(width: 40, height: 40)
                
                            //dismiss버튼
                                .overlay(Button{
                        isActivatedShowImageView.toggle()
                                } label: {
                                    //네비게이션 시 : chevron.backward, 모달 시 : xmark
                                    Image(systemName: "chevron.backward")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 20))
                                })
                                .shadow(color: .black, radius: 26, y: 12)
                                .padding(.leading, 20)
                            Spacer()
                
                        }.overlay(Text("전통시장")
                          //글자 폰트 사이즈 조정
                          .font(Font.system(size: 18))
                          .fontWeight(.semibold)
                          .foregroundColor(.white))
            
                        .padding(.top, 16).padding(.bottom, 16)
                
                        .background(Color.black.opacity(0.55).ignoresSafeArea())
            
                        Spacer()
                        ScrollViewReader{ proxy in
                
                    
                            HStack(spacing: 8){
                                ForEach(changedImagesList){image in
                                    Image(image.imagePath)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 36, height: 48)
                                        .background(.black)
                                        .overlay(
                                    Rectangle()
                                    .strokeBorder(Color.white, lineWidth:  1)
                                    .opacity(currentPost == image.id ? 1 : 0)
                                    ).id(image.id)
                                        .onTapGesture {
                                        currentPost = image.id
                                }
                                
                        }
                    }
                .onChange(of: currentPost) { newValue in
                    
                        proxy.scrollTo(currentPost, anchor: .bottom)
                    
                }
                
                .frame(width : UIScreen.main.bounds.width,height : 100)
                    .background(Color.black.opacity(0.55).ignoresSafeArea())
            }
               
            }.opacity(tapGesture ? 0 : 1)
        )
        .simultaneousGesture(TapGesture(count: 2).onEnded({
            withAnimation{imageScale = imageScale > 1 ? 1 : 4}
            
        }))
        .onTapGesture {
            tapGesture.toggle()
        }
        .onAppear{
            for originImage in originImageList{
                changedImagesList.append(Images(imagePath: originImage))
            }
    
            currentPost = changedImagesList[indexValue].id
            
        }.background(
            .black)
    }
}
