//
//  Operator.swift
//  Calculator
//
//  Created by Stanly Shiyanovskiy on 27.06.2022.
//

import Foundation

final class Operator {
    
    var op: (Double, Double) -> Double
    var isDivision = false
    
    init(_ string: String) {
        if string == "+" {
            op = (+)
        } else if string == "-" {
            op = (-)
        } else if string == "\u{00d7}" {
            op = (*)
        } else {
            op = (/)
            isDivision = true
        }
    }
}
