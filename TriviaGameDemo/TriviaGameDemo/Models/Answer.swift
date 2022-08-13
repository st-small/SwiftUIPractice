//
//  Answer.swift
//  TriviaGameDemo
//
//  Created by Stanly Shiyanovskiy on 12.08.2022.
//

import Foundation

struct Answer: Identifiable {
    let id = UUID()
    let text: AttributedString
    let isCorrect: Bool
}
