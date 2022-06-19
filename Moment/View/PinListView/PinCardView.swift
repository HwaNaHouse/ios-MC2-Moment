//
//  PinCardView.swift
//  Moment
//
//  Created by Sooik Kim on 2022/06/16.
//  Pin List를 구성하는 카드 컴퍼넌트

import SwiftUI

struct PinCardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @GestureState private var movingOffset: CGFloat = .zero
    
    @State private var cardOffset: CGSize = .zero
    @State var deleteButton: Bool = false
    
    @State private var alertShowing = false
    public var pin: Pin?
    @Binding var selectedCategory: Category?
    @Binding var selectedIndex: Int
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.startDate, ascending: false)], animation: .default) private var categories: FetchedResults<Category>
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

// Coredata를 받아오는 작업이 필요함 State
    var body: some View {
        
        
        ZStack {
            // Delete 되면 사라지는 애니메이션을 준다
            if !deleteButton {
            // Delete 버튼
                HStack {
                    Spacer()
                    Button (action : {
                        // DragGesture 중 offset인 movingOffset과, 제스쳐 종료시인 CardOffset이 음수일때 클릭시 알러트 뛰움
                        if cardOffset.width < 0 || movingOffset < 0 {
                            alertShowing = true
                        }
                    }, label: {
                        Text("삭제")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 94)
                            .padding(.leading, 50)
//                            .padding(.trailing, )
                            .padding(.vertical, 35)
                    })
                    .alert("정말 삭제하시겠습니까 ?", isPresented: $alertShowing){
                        Button("취소", role: .cancel) {}
                        Button("삭제", role: .destructive) {
                            if let deleteData = pin {
                                
                                withAnimation{
                                    deleteButton = true
                                    // Category내부 PinList가 변화하였음에도 View를 다시 그리지 않아 뷰를 그리지 않게 한 후 삭제 진행
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                        viewContext.delete(deleteData)
                                    }
                                }
                                PersistenceController.shared.saveContext()
                                
                                
                            }
//                            try viewContext.save()
                        }
                    }
                }
                .background{
                    // DragGesture 중 offset인 movingOffset과, 제스쳐 종료시인 CardOffset이 음수일때 클릭시 투명하게 만듦
                    Color.red.padding(0)
                        .opacity(cardOffset.width < 0 || movingOffset < 0 ? 1: 0)
                }
                .frame(height: 94)
                .cornerRadius(10)
                .padding(.horizontal, 23)
                
                
                // 위에 투명도?
                HStack {
                    //이모티콘
                    Image(pin?.emotion ?? "love")
                        .resizable()
                        .frame(width: 21.5, height: 21.5)
                        .background{
                            Circle()
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color(selectedCategory?.categoryColor ?? "black"))
            
                        }
                        .padding(.leading, 23)
                        .padding(.trailing, 7.5)
                        .padding(.vertical, 34)
                    VStack (alignment: .leading){
                        // Pin title
                        Text(pin?.title ?? "NoNamed")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        // Pin createAt
                        Text(pin?.createdAt ?? Date(), formatter: dateFormatter)
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 7.5)
                    .padding(.vertical, 26)
                    
                    Spacer()
                    // ImageName
                    Image(pin?.photoArray.count ?? 0 > 0 ? pin?.photoArray[0].photoName ?? "0" : "0")
                        .resizable()
                        
                        .cornerRadius(5)
                        .frame(width: 81,height: 74)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 14.43)
                        .padding(.vertical, 10)
                        
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
//
//struct PinCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PinCardView()
//    }
//}
