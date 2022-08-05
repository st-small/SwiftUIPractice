//
//  Suggestion.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 28.07.2022.
//

import SwiftUI

struct Suggestion: Identifiable {
    let id = UUID()
    let text: String
}

var suggestions = [
    Suggestion(text: "SwiftUI"),
    Suggestion(text: "React"),
    Suggestion(text: "Design")
]
