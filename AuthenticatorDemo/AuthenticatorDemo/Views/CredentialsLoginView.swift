//
//  CredentialsLoginView.swift
//  AuthenticatorDemo
//
//  Created by Stanly Shiyanovskiy on 12.08.2022.
//

import SwiftUI

struct CredentialsLoginView: View {
    
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        VStack(spacing: 40) {
            Title()
            
            TextField("Username", text: $username)
            
            SecureField("Password", text: $password)
            
            PrimaryButton(showImage: false, text: "Login")
                .onTapGesture {
                    authenticationManager.authenticateWithCredentials(
                        username: username,
                        password: password
                    )
                }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct CredentialsLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialsLoginView()
            .environmentObject(AuthenticationManager())
    }
}
