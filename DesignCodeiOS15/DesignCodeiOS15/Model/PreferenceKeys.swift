//
//  PreferenceKeys.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 23.07.2022.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CirclePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
