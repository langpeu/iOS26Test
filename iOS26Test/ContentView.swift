//
//  ContentView.swift
//  iOS26Test
//
//  Created by Langpeu on 9/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded: Bool = false
    var body: some View {
        ZStack {
            /// Background Image
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipShape(.rect(cornerRadius: 20))
                
            /// Custom View with Liquid Glass Effect
            Image(systemName: "suit.heart.fill")
                .font(.title)
                .foregroundStyle(.red.gradient)
                .frame(width: 50, height: 50)
            /// Can make any custom glass effect to be interactable!
            /// Can adjust it's background tint as well
                .glassEffect(.regular.tint(.red.opacity(0.35)).interactive(), in: .circle)
        }
    }
}


///note

/*1. Liquid Glass Effect 리퀴드 글래스 효과

새로운 리퀴드 글래스 효과는 거의 모든 시스템 전반의 앱, 컨트롤 등에 사용됩니다.
우리 앱에 이를 적용하는 것은 큰 일이 아닙니다.
다행히도 SwiftUI는 기본 컨트롤뿐 아니라 사용자 정의 뷰에도 리퀴드 글래스 효과를 지원하여, 이러한 효과를 쉽게 추가할 수 있습니다.
그럼 이제 이 글래스 효과를 앱에 어떻게 추가할 수 있는지 살펴봅시다.


*/
