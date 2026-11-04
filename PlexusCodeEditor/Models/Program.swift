import Foundation

struct Program {
    var blocks: [CodeBlock] = []
    var counter = 0
    var message = "Program output"
    var characterX = 0.0
    var characterColor = "mint"
    var nextID: UUID?
    var activeID: UUID?
    var visited: [UUID] = []
    var log: [ExecutionEntry] = []
    var isFinished = false

    mutating func reset() {
        counter = 0
        message = "Program output"
        characterX = 0
        characterColor = "mint"
        nextID = blocks.first(where: { $0.kind == .start })?.id
        activeID = nil
        visited = []
        log = []
        isFinished = false
    }

    // Execution follows stored connections, never the blocks' screen positions.
    mutating func step() {
        guard !isFinished else { return }
        guard visited.count < 200 else {
            finish("Stopped after 200 steps. Check your loop.")
            return
        }
        guard let id = nextID, let block = blocks.first(where: { $0.id == id }) else {
            finish("Connect a Start block and an outgoing path to continue.")
            return
        }
        activeID = id
        visited.append(id)
        var destination = block.next
        switch block.kind {
        case .start: break
        case .message: message = block.value
        case .setCounter, .addCounter, .condition:
            guard let value = Int(block.value), (-100000...100000).contains(value) else {
                finish("Enter a whole number from −100000 to 100000.")
                return
            }
            switch block.kind {
            case .setCounter: counter = value
            case .addCounter: counter += value
            case .condition: destination = counter >= value ? block.next : block.otherwise
            default: break
            }
        case .move:
            guard let distance = Double(block.value), distance.isFinite else {
                finish("Move needs a valid number.")
                return
            }
            characterX = min(100, max(-100, characterX + distance))
        case .color:
            guard ["mint", "blue", "pink"].contains(block.value.lowercased()) else {
                finish("Color must be mint, blue or pink.")
                return
            }
            characterColor = block.value.lowercased()
        case .end:
            finish("Program finished.")
            return
        }
        log.append(ExecutionEntry(text: "\(block.kind.title) \(block.value)"))
        nextID = destination
        if destination == nil { finish("Path ended. Connect another block to continue.") }
    }

    private mutating func finish(_ text: String) {
        log.append(ExecutionEntry(text: text))
        nextID = nil
        isFinished = true
    }

    static var example: Program {
        var start = CodeBlock(kind: .start, value: "", x: 360, y: 85)
        var counter = CodeBlock(kind: .setCounter, value: "3", x: 360, y: 225)
        var condition = CodeBlock(kind: .condition, value: "3", x: 360, y: 365)
        var yes = CodeBlock(kind: .message, value: "You made it happen!", x: 210, y: 525)
        var no = CodeBlock(kind: .message, value: "Try a bigger number.", x: 520, y: 525)
        let end = CodeBlock(kind: .end, value: "", x: 360, y: 695)
        start.next = counter.id
        counter.next = condition.id
        condition.next = yes.id
        condition.otherwise = no.id
        yes.next = end.id
        no.next = end.id
        var program = Program(blocks: [start, counter, condition, yes, no, end])
        program.reset()
        return program
    }
}
