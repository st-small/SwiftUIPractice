//
//  AuthenticationManager.swift
//  AuthenticatorDemo
//
//  Created by Stanly Shiyanovskiy on 11.08.2022.
//

import Foundation
import LocalAuthentication

final class AuthenticationManager: ObservableObject {
    
    @Published private(set) var biometryType: LABiometryType = .none
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var errorDescription: String?
    @Published var showAlert = false
    
    private(set) var context = LAContext()
    private(set) var canEvaluatePolicy = false
    
    init() {
        getBiometryType()
    }
    
    func getBiometryType() {
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        biometryType = context.biometryType
    }
    
    func authenticateWithBiometrics() async {
        context = LAContext()
        
        if canEvaluatePolicy {
            let reason = "Log into your account"
            
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                
                if success {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.showAlert = true
                    self.biometryType = .none
                }
            }
        }
    }
    
    func authenticateWithCredentials(username: String, password: String) {
        if username.lowercased() == "bob" && password == "1234" {
            isAuthenticated = true
        } else {
            errorDescription = "Wrong credentials"
            showAlert = true
        }
    }
    
    func logout() {
        isAuthenticated = false
    }
}
