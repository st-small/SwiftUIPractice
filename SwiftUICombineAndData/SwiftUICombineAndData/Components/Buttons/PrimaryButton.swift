//
//  PrimaryButton.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 17.08.2022.
//

import SwiftUI

struct PrimaryButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @AppStorage("isLiteMode") var isLiteMode: Bool = false
    
    var text: String = "Contact Support"
    
    var body: some View {
        if colorScheme == .dark {
            darkModeButton
        } else {
            lightModeButton
        }
    }
    
    var lightModeButton: some View {
        VStack {
            Text(text)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(
            LinearGradient(
                colors: [Color(#colorLiteral(red: 0.3373903036, green: 0.2152278125, blue: 0.887358427, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(16)
        .foregroundColor(.white)
    }
    
    var darkModeButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 50)
                .angularGradientFlow(colors: [
                    Color(#colorLiteral(red: 0.3843137255, green: 0.5176470588, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 1, green: 0.4470588235, blue: 0.7137254902, alpha: 1)),
                    Color(#colorLiteral(red: 0.8509803922, green: 0.6862745098, blue: 0.8509803922, alpha: 1)),
                    Color(#colorLiteral(red: 0.5921568627, green: 0.8823529412, blue: 0.831372549, alpha: 1)),
                    Color(#colorLiteral(red: 0.3843137255, green: 0.5176470588, blue: 1, alpha: 1)),
                ])
                .if(!isLiteMode) { view in
                    view.blur(radius: 8)
                }
            
            Text(text)
                .linearGradientBackground(colors: [
                    Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1)),
                    
                ])
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Color(#colorLiteral(red: 0.1019607843, green: 0.07058823529, blue: 0.2431372549, alpha: 0.9))
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white, lineWidth: 1)
                        .blendMode(.overlay)
                )
        }
        .frame(height: 50)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton()
            .padding()
            .preferredColorScheme(.dark)
        PrimaryButton()
            .padding()
            .preferredColorScheme(.light)
    }
}
