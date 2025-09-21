//
//  ContentView.swift
//  iOS26Test
//
//  Created by Langpeu on 9/20/25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var todos: [Todo] = []
    @State private var isWriting: Bool = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    Text(todo.task)
                }
            }
            .navigationTitle("Todo")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "apple.intelligence") {
                        let propmt = "Create 10 todo list items in Korean"
                        Task {
                            do {
                                let session = LanguageModelSession()
                                let response = session.streamResponse(generating: [Todo].self) {
                                    propmt
                                }
                                
                                isWriting = true
                                for try await chunkTodos in response {
                                    self.todos = chunkTodos.content.compactMap({
                                        if let id = $0.id, let task = $0.task {
                                            return .init(id: id, task: task)
                                        }
                                        
                                        return nil
                                    })
                                }
                                
                                isWriting = false
                            }catch {
                                isWriting = false
                                print(error.localizedDescription)
                            }
                        }
                    }
                    .disabled(isWriting)
                }
            })
            .scrollEdgeEffectStyle(.hard, for: .top)
        }
    }
}

@Generable
struct Todo: Identifiable {
    var id: String
    @Guide(description: "칫솔질") //어떤 내용이 올지 샘플을 제공함
    var task: String
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
 
 +. streamResponse
 코드 몇 줄만으로도 우리는 이 새로운 SDK를 이용해 AI 채팅을 만들 수 있습니다.
 하지만 답변이 너무 오래 걸린다는 것을 눈치채셨나요?

 네, 그 이유는 제가 한 번에 전체 결과를 요청하고 있기 때문입니다.
 하지만 부분적인 반복 결과(Partial Iterative Results)를 받을 수 있는 방법이 있습니다.
 이 방식은 요즘 AI 채팅에서 가장 흔히 사용되고 있죠.

 
 +. FoundationModels (@Generable)

 FoundationModels에는 **“@Generable”**이라는 매크로가 포함되어 있으며, 이를 통해 LanguageModelSession이 지정된 모델을 위한 데이터를 생성할 수 있습니다.

 이 예시에서는 **“Todo”**라는 이름의 모델을 생성할 것입니다.
 이 매크로를 사용하면, 언어 모델에게 무작위 할 일(todo) 목록을 생성하도록 요청할 수 있습니다.
 비록 이것이 실질적인 사용 사례는 아닐 수 있지만, 다른 많은 시나리오에서 유용하게 활용될 수 있습니다!
 
 +. @Guide()

 이것은 LanguageModel에 이러한 속성을 채우는 데 필요한 컨텍스트를 제공합니다.
 또한, @Generable에도 이러한 설명을 제공할 수 있습니다!
 
 +. scrollEdgeEffectStyle()
 
 기본적으로, List, Navigation, 그리고 다른 UI 컴포넌트들은 이제 안전 영역(safe areas)에
 부드러운 블러 효과(Progressive Blurs라고도 불림)를 갖습니다. 그러나 SwiftUI는 이러한 효과를
 제어할 수 있는 간단한 수정자(modifier)를 제공합니다.
 
 +. backgroundExtensionEffect()

 작은 이미지를 사용할 때 잠금 화면 상단에서 확장된 블러 효과가 나타나는 것을 모두 본 적이 있을 것입니다.
 그런데 이제 이 기능이 SwiftUI에서 modifier(수정자) 로 제공됩니다!
 이 수정자는 뷰를 사용 가능한 안전 영역(safe areas)까지 확장하며, 그 영역에 은은한 블러 효과를 적용합니다.


*/
