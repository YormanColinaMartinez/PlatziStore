//
//  SplashView.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import SwiftUI

struct SplashView: View {
    
    //MARK: - Properties -
    @State private var imageOffset: CGFloat = UIScreen.main.bounds.width
    @State private var textOffsets: [CGFloat] = []
    let text: String = Login.platziStore.description
    
    //MARK: - Body -
    var body: some View {
        HStack {
            Image(Icons.platziLogo.description)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(x: imageOffset)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 1)) {
                        imageOffset = 0
                    }
                }
            
            HStack(spacing: 0) {
                ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                    Text(String(char))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: textOffsets.count > index ? textOffsets[index] : UIScreen.main.bounds.width)
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 1).delay(Double(index) * 0.05)) {
                                if textOffsets.count > index {
                                    textOffsets[index] = 0
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            textOffsets = Array(repeating: UIScreen.main.bounds.width, count: text.count)
        }
    }
}
