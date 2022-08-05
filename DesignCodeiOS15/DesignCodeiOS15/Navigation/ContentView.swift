//
//  ContentView.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 20.07.2022.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("showModal") var showModal = false
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedTab {
            case .home:
                HomeView()
            case .explore:
                ExploreView()
            case .notifications:
                Text("")
            case .library:
                Text("")
            }
            
            TabBar()
                .offset(y: model.showDetail ? 200 : 0)
            
            if showModal {
                ModalView()
                .zIndex(1)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 44)
        }
        .dynamicTypeSize(.large ... .xxLarge)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(Model())
    }
}
