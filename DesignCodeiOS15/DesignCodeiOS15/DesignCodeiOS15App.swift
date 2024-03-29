//
//  DesignCodeiOS15App.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 20.07.2022.
//

import SwiftUI

@main
struct DesignCodeiOS15App: App {
    
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
