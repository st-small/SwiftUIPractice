//
//  LoginView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Stanly Shiyanovskiy on 11.07.2022.
//

import SwiftUI

struct LoginView: View {
    
    let didCompleteLoginProcess: () -> Void
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    
    @State private var loginStatusMessage = ""
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker here")
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 128, height: 128, alignment: .center)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    
                    Text(loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create account")
            .background(
                Color(.init(white: 0, alpha: 0.05))
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(.stack)
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func createNewAccount() {
        if image == nil {
            loginStatusMessage = "You must select avatar image"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                loginStatusMessage = "Failed to create user: \(error.localizedDescription)"
                return
            }
            
            loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            persistImageToStorage()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                loginStatusMessage = "Failed to login user: \(error.localizedDescription)"
                return
            }
            
            loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            didCompleteLoginProcess()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url!.absoluteString)
                
                guard let url = url else { return }
                storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [
            "email": email,
            "uid": uid,
            "profileImageUrl": imageProfileUrl.absoluteString
        ]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
                
                didCompleteLoginProcess()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: { })
    }
}
