/*
Purpose: Lists the five supported IF comparisons.
MVVM: A model enum; Program evaluates it, and the inspector edits it through EditorViewModel.
Functions and properties:
- evaluate(_:_:) compares two integers and returns the IF branch decision.
- id uses the raw operator string to identify each inspector option.
Codable preserves the selected operator in saved blocks.
*/

import Foundation

enum ComparisonOperator: String, CaseIterable, Identifiable, Codable {
    case greaterThanOrEqual = ">="
    case equal = "="
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case lessThan = "<"

    var id: String { rawValue }

    func evaluate(_ left: Int, _ right: Int) -> Bool {
        switch self {
        case .greaterThanOrEqual: left >= right
        case .equal: left == right
        case .lessThanOrEqual: left <= right
        case .greaterThan: left > right
        case .lessThan: left < right
        }
    }
}
