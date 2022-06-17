//
//  AddDetailTest.swift
//  Moment
//
//  Created by 김민재 on 2022/06/12.
//

import SwiftUI

/*
 *
 * Add Detail 뷰 호출용 임시
 *
 */

struct AddDetailTest: View {
    @State private var isActive : Bool = false
    
    var body: some View {
        NavigationView{
            NavigationLink(destination: PinDetailAddView(), isActive: self.$isActive) {
                Text("AAA")
            }
            .isDetailLink(false)
        }
        .environment(\.rootPresentationMode, self.$isActive)
    }
}

struct AddDetailTest_Previews: PreviewProvider {
    static var previews: some View {
        AddDetailTest()
    }
}
