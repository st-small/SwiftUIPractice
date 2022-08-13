//
//  ProgressBar.swift
//  TriviaGameDemo
//
//  Created by Stanly Shiyanovskiy on 12.08.2022.
//

import SwiftUI

struct ProgressBar: View {
    
    let progress: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: 350, maxHeight: 4)
                .foregroundColor(
                    Color(
                        hue: 1,
                        saturation: 0,
                        brightness: 0.564,
                        opacity: 0.327
                    )
                )
                .cornerRadius(10)
            
            Rectangle()
                .frame(width: progress, height: 4)
                .foregroundColor(.accentColor)
                .cornerRadius(10)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 50)
    }
}
