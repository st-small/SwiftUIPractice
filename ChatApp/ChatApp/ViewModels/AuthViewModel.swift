//
//  AuthViewModel.swift
//  ChatApp
//
//  Created by Stanly Shiyanovskiy on 29.06.2022.
//

import FirebaseAuth
import Foundation

final class AuthViewModel {
    
    static func isUserLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
    
    static func getLoggedInUserId() -> String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    static func logout() {
        try? Auth.auth().signOut()
    }
}
