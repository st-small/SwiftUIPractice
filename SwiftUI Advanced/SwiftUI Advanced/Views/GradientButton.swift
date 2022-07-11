//
//  GradientButton.swift
//  SwiftUI Advanced
//
//  Created by Stanly Shiyanovskiy on 05.07.2022.
//

import SwiftUI

struct GradientButton: View {
    
    @State
    private var angle = 0.0
    
    var gradient1: [Color] = [
        Color(red: 101/255, green: 134/255, blue: 1),
        Color(red: 1, green: 64/255, blue: 80/255),
        Color(red: 109/255, green: 1, blue: 185/255),
        Color(red: 39/255, green: 232/255, blue: 1)
    ]
    
    var buttonTitle: String
    var buttonAction: () -> Void
    
    var body: some View {
        Button { buttonAction() } label: {
            GeometryReader() { geo in
                ZStack {
                    AngularGradient(colors: gradient1, center: .center, angle: .degrees(angle))
                        .blendMode(.overlay)
                        .blur(radius: 8)
                        .mask(
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 50)
                                .frame(maxWidth: geo.size.width - 16)
                                .blur(radius: 8)
                        )
                        .onAppear() {
                            withAnimation(.linear(duration: 7)) {
                                angle += 350
                            }
                        }
                    GradientText(text: buttonTitle)
                        .font(.headline)
                        .frame(width: geo.size.width - 16)
                        .frame(height: 50)
                        .background(
                            Color("tertiaryBackground")
                                .opacity(0.9)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 1)
                                .blendMode(.normal)
                                .opacity(0.7)
                        )
                        .cornerRadius(16)
                }
            }
            .frame(height: 50)
        }
    }
}

struct GradientButton_Previews: PreviewProvider {
    static var previews: some View {
        GradientButton(buttonTitle: "Sign up", buttonAction: { })
    }
}
