//
//  FAQ.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 17.08.2022.
//

import Foundation

struct FAQ: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String
}
