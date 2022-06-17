//
//  PinCardView.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//  Pin List를 구성하는 카드 컴퍼넌트

import SwiftUI

struct PinCardView: View {

    
    @GestureState private var movingOffset: CGFloat = .zero
    
    @State private var cardOffset: CGSize = .zero
    @State var deleteButton: Bool = false
    
    @State private var alertShowing = false
    public var pin: Pin?

// Coredata를 받아오는 작업이 필요함 State
    var body: some View {
        ZStack {
            if !deleteButton {
            // Delete 버튼
                HStack {
                    Spacer()
                    Button (action : {
                        if cardOffset.width < 0 || movingOffset < 0 {
                            alertShowing = true
                        }
                    }, label: {
                        Text("삭제")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 95)
                            .padding(.leading, 50)
//                            .padding(.trailing, )
                            .padding(.vertical, 35)
                    })
                    .alert("정말 삭제하시겠습니까 ?", isPresented: $alertShowing){
                        Button("취소", role: .cancel) {}
                        Button("삭제", role: .destructive) {
                            
                        }
                    }
                }
                .background{
                    Color.red.padding(0)
                        .opacity(cardOffset.width < 0 || movingOffset < 0 ? 1: 0)
                }
                .frame(height: 95)
                .cornerRadius(10)
                .padding(.horizontal, 23)
                
                
                // 위에 투명도?
                HStack {
                    //이모티콘
                    Text(pin?.emotion ?? "😀")
                        .font(.custom("TossFaceFontMac", size: 28))
                        .background{
                            Circle()
                                .stroke(.red ,lineWidth: 5)
                                .offset(y:0.5)
                        }
                        .padding(.leading, 23)
                        .padding(.trailing, 7.5)
                        .padding(.vertical, 26)
                    VStack (alignment: .leading){
                        // Pin title
                        Text(pin?.title ?? "NoNamed")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        // Pin createAt
                        Text(changeDateToString(date: pin?.createdAt ?? Date()))
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 7.5)
                    .padding(.vertical, 26)
                    
                    Spacer()
                    // ImageName
                    Image(pin?.photoArray.randomElement()?.photoName ?? "0")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                        .frame(width: 81,height: 74)
                        .padding(.trailing, 14.43)
                        
                }
                .background(.white)
                .cornerRadius(10)
                .offset(x: movingOffset)
                
                .padding(.horizontal, 23)
                .gesture(
                    DragGesture()
                        // 카드 드래그 시 오프셋 적용
                        .updating($movingOffset) { dragValue, state, _ in
                            
                            if dragValue.translation.width < 0 {
                                state = dragValue.translation.width
                            }
                            
                        }
                    
                    // 드래그 종료 시 위치 고정 용
                        .onEnded { gesture in
                            
                            if gesture.translation.width < -80 {
//                                withAnimation {
                                    cardOffset.width = -80
//                                }
                            } else {
                                withAnimation {
                                    cardOffset.width = .zero
                                }
                            }
                        }
                )
                .offset(x: cardOffset.width)
            }
        }
        .scaleEffect(y: deleteButton ? 0 : 1)
        .shadow(color: .black.opacity(0.08), radius: 26, y: 12)

        
    }
    
    func changeDateToString(date: Date) -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        result = dateFormatter.string(from: date)
        
        return result
    }
}

struct PinCardView_Previews: PreviewProvider {
    static var previews: some View {
        PinCardView()
    }
}
