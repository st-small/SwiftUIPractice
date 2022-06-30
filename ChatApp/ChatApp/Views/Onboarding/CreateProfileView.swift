//
//  CreateProfileView.swift
//  ChatApp
//
//  Created by Stanly Shiyanovskiy on 29.06.2022.
//

import SwiftUI

struct CreateProfileView: View {
    
    @Binding
    var currentStep: OnboardingStep
    
    @State
    var firstName = ""
    @State
    var lastName = ""
    
    var body: some View {
        VStack {
            Text("Setup your Profile")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Just a few more details to get started")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                
            } label: {
                
                ZStack {
                    
                    Circle()
                        .foregroundColor(.white)
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                    
                    Image(systemName: "camera.fill")
                        .tint(Color("icons-input"))
                }
                .frame(width: 134, height: 134)
            }

            Spacer()
            
            TextField("Given Name", text: $firstName)
                .textFieldStyle(CreateProfileTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CreateProfileTextFieldStyle())
            
            Spacer()
            
            Button {
                currentStep = .contacts
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding()
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
