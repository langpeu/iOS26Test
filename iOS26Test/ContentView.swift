//
//  ContentView.swift
//  iOS26Test
//
//  Created by Langpeu on 9/20/25.
//

import SwiftUI

// ✅ @Animatable 매크로는 View나 ViewModifier에 사용
@Animatable
struct ScaleEffect: ViewModifier {
    var scale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
    }
}

@Animatable
struct RotatingView: View {
    var rotation: Double
    
    var body: some View {
        Image(systemName: "star.fill")
            .font(.largeTitle)
            .foregroundColor(.yellow)
            .rotationEffect(.degrees(rotation))
    }
}

// ✅ 사용 예제
struct AnimatableMacroDemo: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            // ViewModifier 사용
            Text("Scalable Text")
                .font(.title)
                .modifier(ScaleEffect(scale: isAnimating ? 1.5 : 1.0))
            
            // Animatable View 사용
            RotatingView(rotation: isAnimating ? 360 : 0)
            
            Button("Animate") {
                withAnimation(.easeInOut(duration: 2.0)) {
                    isAnimating.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Shape의 올바른 animatableData 구현 패턴들

// 단일 값 애니메이션
struct AnimatedLine: Shape {
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.width * progress, y: rect.midY))
        }
    }
}

// 복수 값 애니메이션 (AnimatablePair 사용)
struct AnimatedArc: Shape {
    var startAngle: Double
    var endAngle: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle, endAngle) }
        set {
            startAngle = newValue.first
            endAngle = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: min(rect.width, rect.height) / 2,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
        }
    }
}

// Swift 6.x + iOS 26 스타일 사용법
struct ModernAnimationDemo: View {
    @State private var progress: CGFloat = 0
    @State private var arcProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 30) {
            // 진행바 애니메이션
            AnimatedLine(progress: progress)
                .stroke(.blue, lineWidth: 4)
                .frame(height: 4)
            
            // 호 애니메이션
            AnimatedArc(startAngle: 0, endAngle: arcProgress * 360)
                .stroke(.purple, lineWidth: 8)
                .frame(width: 100, height: 100)
            
            Button("Start Animation") {
                withAnimation(.easeInOut(duration: 2.0)) {
                    progress = progress == 0 ? 1.0 : 0
                    arcProgress = arcProgress == 0 ? 1.0 : 0
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


///note

/*
 ✅ Liquid Glass Effects 리퀴드 글래스 효과
 
 새로운 리퀴드 글래스 효과는 거의 모든 시스템 전반의 앱, 컨트롤 등에 사용됩니다.
 우리 앱에 이를 적용하는 것은 큰 일이 아닙니다.
 다행히도 SwiftUI는 기본 컨트롤뿐 아니라 사용자 정의 뷰에도 리퀴드 글래스 효과를 지원하여, 이러한 효과를 쉽게 추가할 수 있습니다.
 그럼 이제 이 글래스 효과를 앱에 어떻게 추가할 수 있는지 살펴봅시다.
 
 ✅ GlassEffectContainer
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
 
 ✅ FoundationModels (SDK)
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
 
 ✅ scrollEdgeEffectStyle()
 
 기본적으로, List, Navigation, 그리고 다른 UI 컴포넌트들은 이제 안전 영역(safe areas)에
 부드러운 블러 효과(Progressive Blurs라고도 불림)를 갖습니다. 그러나 SwiftUI는 이러한 효과를
 제어할 수 있는 간단한 수정자(modifier)를 제공합니다.
 
 ✅ backgroundExtensionEffect()
 
 작은 이미지를 사용할 때 잠금 화면 상단에서 확장된 블러 효과가 나타나는 것을 모두 본 적이 있을 것입니다.
 그런데 이제 이 기능이 SwiftUI에서 modifier(수정자) 로 제공됩니다!
 이 수정자는 뷰를 사용 가능한 안전 영역(safe areas)까지 확장하며, 그 영역에 은은한 블러 효과를 적용합니다.
 
 ✅ Rich TextEditor
 
 마침내, TextEditor가 이제 AttributedString 을 Binding으로 지원합니다.
 또한 기본 제공 TextEditor에는 몇 가지 유용한 리치 텍스트 편집 기능 옵션도 포함되어 있습니다!
 
 ✅ Native WebView
 
 SwiftUI가 이제 Native WebView 를 지원합니다. 스크롤 위치 추적, 스크롤 위치 업데이트,
 특정 제스처 비활성화 등 다양한 기본 내장 기능들이 포함되어 있습니다.
 
 +.WebPage()
 WebPage를 사용하여 페이지를 불러올 수도 있습니다.
 이렇게 하면 웹 페이지를 보다 프로그래밍적으로 제어할 수 있습니다!
 
 ✅ TabView Customizations
 
 기본적으로, SwiftUI는 새로운 **iOS 26 글로시 탭 바(glossy tab bar)** 에 자동으로 적용됩니다.
 (단, 앱이 이전에 네이티브 탭 바를 사용했을 경우이며, 커스텀 탭 바를 사용한 경우는 제외됩니다.)
 
 iOS 26에서는 **검색(Search) 역할의 탭 아이템**이 탭 바에서 제외되어, 탭 바와는 별도로 표시됩니다!
 
 +. tabViewBottomAccessory()
 iOS 26에서는 TabView 가 이제 탭 바 위에 액세서리 뷰를 추가하는 것을 지원합니다. (Apple Music 앱과 동일한 방식입니다.)
 
 +. tabBarMinimizeBehaviour()
 Apple Music 앱과 마찬가지로, 이제 탭 바는 스크롤을 내리거나(Scrolled Down) 올릴 때(Scrolled Up)
 최소화(minimizing)를 지원합니다.
 스크롤을 내리거나 올리면, 검색(Search) 역할의 탭 아이템은 오른쪽으로 이동하고, 탭 바는 최소화되어 왼쪽으로 밀립니다.
 또한, 액세서리 뷰는 중앙으로 이동하게 됩니다.
 
 ✅ ToolBarSpacer
 
 기본적으로, 모든 ToolBar 아이템은 iOS 26에서 함께 그룹화됩니다.
 그러나 경우에 따라 버튼을 그룹에서 분리해야 할 필요가 있을 수 있습니다.
 이 새로운 modifier는 ToolBar 아이템을 분리하거나, 여러 개의 ToolBar 아이템 그룹을 만드는 데 특히 유용합니다.
 
 
 ✅ @Animatable
 
 보시는 것처럼, 이 원(circle) 모양을 애니메이션화하려면, 이전에는 Shape의 모든 속성을
 animatable 프로토콜에 맞게 구현해야 했습니다.
 그러나 이 간단한 매크로만 사용하면 전체 Shape가 애니메이션화될 수 있습니다.
 그런데, 만약 특정 속성에는 애니메이션이 필요하지 않다면 어떻게 할까요?
 그 경우에는 해당 속성에 @AnimatableIgnored 매크로를 사용할 수 있습니다!
 
 */
