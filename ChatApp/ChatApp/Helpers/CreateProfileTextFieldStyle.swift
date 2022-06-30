//
//  CreateProfileTextFieldStyle.swift
//  ChatApp
//
//  Created by Stanly Shiyanovskiy on 30.06.2022.
//

import SwiftUI

struct CreateProfileTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color("input"))
                .cornerRadius(8)
                .frame(height: 46)
            
            configuration
                .font(.tabBar)
                .padding()
        }
    }
}
