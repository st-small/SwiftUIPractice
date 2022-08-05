//
//  Tab.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 22.07.2022.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
    let tab: Tab
    let color: Color
}

var tabItems = [
    TabItem(text: "Learn Now", icon: "house", tab: .home, color: .teal),
    TabItem(text: "Explore", icon: "magnifyingglass", tab: .explore, color: .blue),
    TabItem(text: "Notifications", icon: "bell", tab: .notifications, color: .red),
    TabItem(text: "Library", icon: "rectangle.stack", tab: .library, color: .pink)
]

enum Tab: String {
    case home
    case explore
    case notifications
    case library
}

struct TabPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
