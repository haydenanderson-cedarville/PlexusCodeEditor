/*
Purpose: Defines block kinds, individual blocks, and execution-log entries.
MVVM: Model data used by Program and EditorViewModel; no SwiftUI dependency.
Members:
- BlockKind.id supplies stable identity for the block library.
- title, detail, and defaultValue describe each kind and its initial input.
- CodeBlock stores an ID, value, canvas coordinates, and outgoing connection IDs.
- comparisonOperator gets the saved comparison or >= for older projects; its setter stores a choice.
- CodeBlock.title includes the selected comparison for IF blocks.
- ExecutionEntry stores one identifiable log message.
There are no explicit functions; Swift synthesizes initializers, equality, and Codable support.
*/

import Foundation

enum BlockKind: String, CaseIterable, Identifiable, Codable {
    case start, message, setCounter, addCounter, condition, move, color, end
    var id: String { rawValue }
    var title: String {
        switch self {
        case .start: "Start"
        case .message: "Show message"
        case .setCounter: "Set counter"
        case .addCounter: "Add to counter"
        case .condition: "If counter"
        case .move: "Move character"
        case .color: "Change color"
        case .end: "Finish"
        }
    }
    var detail: String {
        switch self {
        case .start: "The entry point"
        case .message: "Speak in the preview"
        case .setCounter: "Give counter a value"
        case .addCounter: "Increase or decrease"
        case .condition: "Choose between two paths"
        case .move: "Move horizontally"
        case .color: "Choose blue, mint or pink"
        case .end: "Stop the program"
        }
    }
    var defaultValue: String {
        switch self {
        case .message: "Hello, world!"
        case .setCounter: "3"
        case .addCounter: "1"
        case .condition: "3"
        case .move: "40"
        case .color: "mint"
        default: ""
        }
    }
}

struct CodeBlock: Identifiable, Equatable, Codable {
    var id = UUID()
    let kind: BlockKind
    var value: String
    var x: Double
    var y: Double
    var next: UUID?
    var otherwise: UUID?
    // Older projects have no comparison key and continue to use >=.
    var comparison: ComparisonOperator?

    var comparisonOperator: ComparisonOperator {
        get { comparison ?? .greaterThanOrEqual }
        set { comparison = newValue }
    }

    var title: String {
        kind == .condition ? "If counter \(comparisonOperator.rawValue)" : kind.title
    }
}

struct ExecutionEntry: Identifiable, Equatable {
    let id = UUID()
    let text: String
}
