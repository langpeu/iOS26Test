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
                            .glassEffectTransition(.identity)
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
