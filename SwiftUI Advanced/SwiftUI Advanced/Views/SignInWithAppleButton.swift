//
//  SignInWithAppleButton.swift
//  SwiftUI Advanced
//
//  Created by Stanly Shiyanovskiy on 09.07.2022.
//

import AuthenticationServices
import SwiftUI

struct SignInWithAppleButton: UIViewRepresentable {
    
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}

