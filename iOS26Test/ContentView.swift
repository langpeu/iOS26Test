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
                .overlay(alignment: .bottom) {
                    GlassEffectContainer(spacing: 20) {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            if isExpanded {
                                Group {
                                    Image(systemName: "suit.heart.fill")
                                        .font(.title)
                                        .foregroundStyle(.red.gradient)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "magnifyingglass")
                                        .font(.title)
                                        .foregroundStyle(.white.gradient)
                                        .frame(width: 50, height: 50)
                                }
                                .glassEffect(.regular, in: .circle)
                                //.glassEffectTransition(.identity) //이 모디파이어를 사용하여 모핑 효과와 애니메이션을 제거할 수 있습니다!
                            }
                            
                            Button {
                                withAnimation(.smooth(duration: 1, extraBounce: 0)) {
                                    isExpanded.toggle()
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title)
                                    .foregroundStyle(.white.gradient)
                                    .frame(width: 40, height: 40)
                            }
                            .buttonStyle(.glass)
                        }
                    }
                    .padding(15)
                }
        }
    }
}


///note

/*
 1. Liquid Glass Effects 리퀴드 글래스 효과
 
 새로운 리퀴드 글래스 효과는 거의 모든 시스템 전반의 앱, 컨트롤 등에 사용됩니다.
 우리 앱에 이를 적용하는 것은 큰 일이 아닙니다.
 다행히도 SwiftUI는 기본 컨트롤뿐 아니라 사용자 정의 뷰에도 리퀴드 글래스 효과를 지원하여, 이러한 효과를 쉽게 추가할 수 있습니다.
 그럼 이제 이 글래스 효과를 앱에 어떻게 추가할 수 있는지 살펴봅시다.

 2. GlassEffectContainer
 (Morphing 및 그룹화에 사용됨)
 
 SwiftUI는 GlassEffectContainer라는 네이티브 컨테이너를 제공합니다.
 이 컨테이너를 사용하면 손쉽게 모핑 효과를 만들고, 여러 뷰를 그룹화하여 단일 글래스 효과를 구현할 수 있습니다.

 참고:
 모핑 효과나 다른 효과들은 간격(Spacing)이 서로 일치하지 않으면 동작하지 않는다는 것을 알게 되었습니다.
 예를 들어, VStack에 간격을 20으로 설정했다면, 동일한 간격을 Container에도 적용해야 합니다.
 
    glassEffectTransition()
    예를 들어, 앱에서 특정 설정이 활성화되었을 때 애니메이션이 필요하지 않은 경우(예: “Reduce Animations” 토글),
    이 모디파이어를 사용하여 모핑 효과와 애니메이션을 제거할 수 있습니다!

 3. FoundationModels (SDK)
 (온디바이스 인텔리전스)
 
 Xcode 26에는 이제 FoundationModels SDK가 포함되어, 온디바이스 인텔리전스 모델을 활용할 수 있습니다.
 이 모델들은 디바이스 내에서 동작하기 때문에, 디바이스가 오프라인 상태여도 기능을 수행할 수 있습니다.
 이제 이 새로운 SDK의 핵심적인 활용 사례들을 살펴보겠습니다.

*/
