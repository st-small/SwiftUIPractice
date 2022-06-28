//
//  RootView.swift
//  ChatApp
//
//  Created by Stanly Shiyanovskiy on 28.06.2022.
//

import SwiftUI

struct RootView: View {
    
    @State
    var selectedTab: Tabs = .contacts
    
    var body: some View {
        
        VStack {
            Text("Hello, world!")
                .padding()
                .font(Font.chatHeading)
            
            Spacer()
            
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
