//
//  ContentView.swift
//  RecipeSaver
//
//  Created by Stanly Shiyanovskiy on 13.08.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabBar()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RecipesViewModel())
    }
}
