//
//  ContentView.swift
//  iOS26Test
//
//  Created by Langpeu on 9/20/25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var answer: String = ""
    @State private var disableControls: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                Text(answer)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(15)
            }
            .safeAreaBar(edge: .bottom) {
                HStack(spacing: 10) {
                    TextField("Prompt", text: $prompt)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .glassEffect(.regular, in: .capsule)
                    
                    Button {
                        Task {
                            guard !prompt.isEmpty else { return }
                            
                            do {
                                let session = LanguageModelSession()
                                disableControls = true
                                
                                let answer = try await session.respond(to: prompt)
                                self.answer = answer.content
                                
                                
                                disableControls = false
                            }catch {
                                disableControls = false
                                print(error.localizedDescription)
                            }
                        }
                        
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(.glass)
                }
                .disabled(disableControls)
                .padding(25)
                
            }
            .navigationTitle("Foundataion Model")
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
 
    glassUnion()
    예를 들어, 두 개의 뷰를 그룹화하여 별도의 HStack/VStack을 작성하지 않고 단일 글래스 효과를 만들고 싶다면,
    이 모디파이어를 사용할 수 있습니다.
    이 모디파이어는 각 뷰가 개별적으로 효과를 가지는 대신, 단일 글래스 효과를 적용합니다!

 3. FoundationModels (SDK)
 (온디바이스 인텔리전스)
 
 Xcode 26에는 이제 FoundationModels SDK가 포함되어, 온디바이스 인텔리전스 모델을 활용할 수 있습니다.
 이 모델들은 디바이스 내에서 동작하기 때문에, 디바이스가 오프라인 상태여도 기능을 수행할 수 있습니다.
 이제 이 새로운 SDK의 핵심적인 활용 사례들을 살펴보겠습니다.

*/
