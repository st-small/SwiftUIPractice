//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Stanly Shiyanovskiy on 27.06.2022.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorHome()
                .environmentObject(Calculator())
        }
    }
}
