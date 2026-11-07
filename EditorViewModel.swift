/*
Purpose: Coordinates editing, presentation data, execution, and project autosave.
MVVM: ContentView owns this observable view model with @State. Child views borrow
it; InspectorView uses @Bindable. Program/CodeBlock hold rules and data, while
ProjectLibraryViewModel writes project snapshots and SettingsViewModel supplies preferences.
Functions:
- init(project:library:settings:) connects dependencies and restores blocks with fresh runtime state.
- saveProject() copies blocks into the project, updates its date, and reports save failures.
- flowScale(in:) calculates a nonnegative scale that fits flowBounds inside a viewport.
- color(for:) and symbol(for:) translate block kinds into SwiftUI colors and SF Symbols.
- add(_:x:y:) inserts a bounded block, enforces one Start, and clears execution state.
- acceptDrop(_:at:) validates drag data, inserts it at canvas coordinates, and reports acceptance.
- select(_:) selects a block or connects a pending output to it.
- beginConnection(_:otherwise:) records which output awaits a destination.
- move(_:by:) applies a drag translation within the canvas limits.
- deleteSelected() removes the selected block and references to it.
- disconnectSelected() clears the selected block's outgoing connections.
- step() executes one model step, restarting finished programs when needed.
- run() resets and executes steps asynchronously at the configured interval.
- stop() cancels the running task without clearing its output.
- reset() stops execution and clears runtime/connection state.
- loadExample() replaces the current graph with Program.example.
- newProgram() replaces the graph with one Start block.
Properties and observers:
- program.didSet autosaves only when blocks change, not on every execution step.
- projectName, blocks, and selectedBlock expose model data to views.
- selectedValue and selectedComparison get/set the selection, resetting execution after edits.
- flowBounds encloses all nodes and their connections with visual margins.
- stageColor translates the program's color name into a display color.
Selection, connection, status, and running properties are observed by their consuming views.
*/

import SwiftUI

@MainActor
@Observable
class EditorViewModel {
    var program = Program.example {
        didSet {
            if program.blocks != oldValue.blocks { saveProject() }
        }
    }
    let settings: SettingsViewModel
    private var project: PlexusProject?
    private var library: ProjectLibraryViewModel?
    var projectName: String { project?.name ?? "Editor" }
    var saveError: String?

    init(project: PlexusProject? = nil, library: ProjectLibraryViewModel? = nil,
         settings: SettingsViewModel? = nil) {
        self.settings = settings ?? SettingsViewModel()
        self.project = project
        self.library = library
        if let project {
            program = Program(blocks: project.blocks)
            program.reset()
        }
    }

    func saveProject() {
        guard var saved = project, let library else { return }
        saved.blocks = program.blocks
        saved.modifiedAt = Date()
        if library.save(saved) {
            project = saved
            saveError = nil
        } else {
            saveError = library.errorMessage
        }
    }
    var selectedID: UUID?
    var connectionSource: UUID?
    var connectingOtherwise = false
    var isRunning = false
    var status = "Select a block to edit."
    private var runTask: Task<Void, Never>?

    var blocks: [CodeBlock] { program.blocks }
    var selectedBlock: CodeBlock? { blocks.first { $0.id == selectedID } }
    var selectedValue: String {
        get { selectedBlock?.value ?? "" }
        set {
            guard !isRunning, let index = program.blocks.firstIndex(where: { $0.id == selectedID }) else { return }
            program.blocks[index].value = newValue
            program.reset()
        }
    }
    var selectedComparison: ComparisonOperator {
        get { selectedBlock?.comparisonOperator ?? .greaterThanOrEqual }
        set {
            guard !isRunning,
                  let index = program.blocks.firstIndex(where: { $0.id == selectedID }),
                  program.blocks[index].kind == .condition else { return }
            program.blocks[index].comparisonOperator = newValue
            program.reset()
        }
    }

    // Include the full 200 × 100 cards, borders, and shadow margins.
    // Connections stay within these extents because they use orthogonal segments.
    var flowBounds: CGRect {
        guard let first = blocks.first else {
            return CGRect(x: 0, y: 0, width: 232, height: 132)
        }
        var bounds = CGRect(x: first.x - 116, y: first.y - 66, width: 232, height: 132)
        for block in blocks.dropFirst() {
            bounds = bounds.union(CGRect(x: block.x - 116, y: block.y - 66, width: 232, height: 132))
        }
        return bounds
    }

    func flowScale(in size: CGSize) -> CGFloat {
        let bounds = flowBounds
        return max(0, min(1, (size.width - 12) / bounds.width, (size.height - 12) / bounds.height))
    }

    var stageColor: Color {
        switch program.characterColor {
        case "blue": .blue
        case "pink": .pink
        default: .mint
        }
    }
    func color(for kind: BlockKind) -> Color {
        switch kind {
        case .start, .end: PlexusTheme.accent
        case .message: .blue
        case .setCounter, .addCounter: .purple
        case .condition: .orange
        case .move, .color: .pink
        }
    }
    func symbol(for kind: BlockKind) -> String {
        switch kind {
        case .start: "play.fill"
        case .message: "text.bubble"
        case .setCounter: "number"
        case .addCounter: "plus"
        case .condition: "arrow.triangle.branch"
        case .move: "arrow.left.and.right"
        case .color: "paintpalette"
        case .end: "stop.fill"
        }
    }
    func add(_ kind: BlockKind, x: Double = 360, y: Double = 400) {
        guard !isRunning else { return }
        guard kind != .start || !blocks.contains(where: { $0.kind == .start }) else {
            status = "A program has one Start block."
            return
        }
        let block = CodeBlock(kind: kind, value: kind.defaultValue,
                              x: min(760, max(110, x)), y: min(950, max(70, y)))
        program.blocks.append(block)
        selectedID = block.id
        program.reset()
        status = "Added \(kind.title). Connect it using an output button."
    }
    func acceptDrop(_ strings: [String], at point: CGPoint) -> Bool {
        guard !isRunning, let string = strings.first,
              let kind = BlockKind(rawValue: string) else { return false }
        let previousCount = blocks.count
        add(kind, x: point.x, y: point.y)
        return blocks.count > previousCount
    }
    func select(_ block: CodeBlock) {
        guard !isRunning else { return }
        if let source = connectionSource {
            guard source != block.id, block.kind != .start else {
                status = "Choose a different block, other than Start."
                return
            }
            if let index = program.blocks.firstIndex(where: { $0.id == source }) {
                if connectingOtherwise { program.blocks[index].otherwise = block.id }
                else { program.blocks[index].next = block.id }
            }
            connectionSource = nil
            program.reset()
            status = "Connected. Run your program to follow the flow."
        }
        selectedID = block.id
    }
    func beginConnection(_ block: CodeBlock, otherwise: Bool = false) {
        guard !isRunning else { return }
        connectionSource = block.id
        connectingOtherwise = otherwise
        status = "Tap the destination block to connect. Tap Cancel to stop."
    }
    func move(_ block: CodeBlock, by translation: CGSize) {
        guard !isRunning, let index = program.blocks.firstIndex(where: { $0.id == block.id }) else { return }
        program.blocks[index].x = min(760, max(110, block.x + translation.width))
        program.blocks[index].y = min(950, max(70, block.y + translation.height))
    }
    func deleteSelected() {
        guard !isRunning, let id = selectedID else { return }
        program.blocks.removeAll { $0.id == id }
        for index in program.blocks.indices {
            if program.blocks[index].next == id { program.blocks[index].next = nil }
            if program.blocks[index].otherwise == id { program.blocks[index].otherwise = nil }
        }
        selectedID = nil
        connectionSource = nil
        program.reset()
    }
    func disconnectSelected() {
        guard !isRunning, let index = program.blocks.firstIndex(where: { $0.id == selectedID }) else { return }
        program.blocks[index].next = nil
        program.blocks[index].otherwise = nil
        program.reset()
    }
    func step() {
        guard !isRunning else { return }
        connectionSource = nil
        if program.isFinished { program.reset() }
        program.step()
    }
    func run() {
        guard !isRunning else { return }
        connectionSource = nil
        program.reset()
        isRunning = true
        runTask = Task { @MainActor [weak self] in //NOTE: Research this line
            guard let self else { return }
            while !Task.isCancelled && !self.program.isFinished {
                withAnimation(.easeInOut(duration: 0.25)) { self.program.step() }
                do { try await Task.sleep(for: .seconds(self.settings.stepDuration)) }
                catch { break }
            }
            if !Task.isCancelled { self.isRunning = false }
        }
    }
    func stop() {
        runTask?.cancel()
        runTask = nil
        isRunning = false
    }
    func reset() {
        stop()
        program.reset()
        connectionSource = nil
        status = "Ready."
    }
    func loadExample() {
        reset()
        program = .example
        selectedID = nil
    }
    func newProgram() {
        reset()
        program = Program()
        selectedID = nil
        add(.start, x: 360, y: 85)
    }
}
