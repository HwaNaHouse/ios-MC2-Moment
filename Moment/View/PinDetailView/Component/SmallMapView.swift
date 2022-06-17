//
//  SmallMapView.swift
//  Moment
//
//  Created by 이규환 on 2022/06/12.
//

import SwiftUI
import MapKit

// 작은 탐나 지도 뷰

struct Location : Identifiable, Codable, Equatable{
    let id : UUID
    var name : String
    var description : String
    var latitude : Double
    var longtitude : Double
}

enum SmallMapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 36.012181, longitude: 129.323627)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}


struct SmallMapView: View {
    // 나중에 바인딩
    @State var region = MKCoordinateRegion(center: SmallMapDetails.startingLocation, span: SmallMapDetails.defaultSpan)
   
    var body: some View {
        VStack(spacing : 0){
            Spacer().frame(height: 22)
        Text("지도")
                .bold()
                .font(Font.system(size: 20))
                .foregroundColor(Color("default"))
            .padding(.bottom, 20)
            
            Map(coordinateRegion: $region, interactionModes: [])
            .overlay(EmoticonView(emoticonColor: Color("default"), emotionFace: "😀"))
            .frame(width: 344, height: 200)
            
        }
    }
}

struct EmoticonView : View {
    var emoticonColor : Color
    var emotionFace : String
    
    var body: some View{
        Circle()
            .frame(width : 40,height: 40, alignment: .center)
            .foregroundColor(emoticonColor)
            .overlay(Text(emotionFace).font(.custom("Toss Face Font Mac", size: 32)))
    }

}

