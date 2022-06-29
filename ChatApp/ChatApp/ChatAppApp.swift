//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Stanly Shiyanovskiy on 28.06.2022.
//

import Firebase
import SwiftUI

@main
struct ChatAppApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
