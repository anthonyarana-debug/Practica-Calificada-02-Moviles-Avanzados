//
//  MathOperation.swift
//  apple_lab08_pract02_UIKit
//

import Foundation

enum MathOperation: CaseIterable {
    case addition, subtraction, multiplication, division

    var title: String {
        switch self {
        case .addition: return "Addition (+)"
        case .subtraction: return "Subtraction (-)"
        case .multiplication: return "Multiplication (×)"
        case .division: return "Division (÷)"
        }
    }

    // Devuelve nil si la operación no es válida (división entre cero)
    func apply(_ a: Double, _ b: Double) -> Double? {
        switch self {
        case .addition: return a + b
        case .subtraction: return a - b
        case .multiplication: return a * b
        case .division: return b == 0 ? nil : a / b
        }
    }
}

extension Double {
    // 70.0 -> "70", 3.14159 -> "3.14159"
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        formatter.usesGroupingSeparator = false
        formatter.decimalSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
