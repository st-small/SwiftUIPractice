//
//  SwiftUI_AdvancedApp.swift
//  SwiftUI Advanced
//
//  Created by Stanly Shiyanovskiy on 05.07.2022.
//

import Firebase
import SwiftUI

@main
struct SwiftUI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SignupView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
