//
//  RecipeSaverApp.swift
//  RecipeSaver
//
//  Created by Stanly Shiyanovskiy on 13.08.2022.
//

import SwiftUI

@main
struct RecipeSaverApp: App {
    
    @StateObject var recipesViewModel = RecipesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipesViewModel)
        }
    }
}
