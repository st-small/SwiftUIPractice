//
//  Extensions.swift
//  TriviaGameDemo
//
//  Created by Stanly Shiyanovskiy on 12.08.2022.
//

import Foundation
import SwiftUI

extension Text {
    func lilacTitle() -> some View {
        self.font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.accentColor)
    }
}
