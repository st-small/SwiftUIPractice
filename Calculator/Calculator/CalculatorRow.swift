//
//  CalculatorRow.swift
//  Calculator
//
//  Created by Stanly Shiyanovskiy on 27.06.2022.
//

import SwiftUI

struct CalculatorRow: View {
    
    var labels: [String]
    var colors: [Color] = [.gray, .gray, .gray, .orange]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4) { index in
                CalculatorButton(label: labels[index], color: colors[index])
            }
        }
    }
}

struct CalculatorRow_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorRow(labels: ["1", "2", "3", "+"])
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
