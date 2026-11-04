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
        add(kind, x: point.x, y: point.y)
        return true
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
        runTask = Task { @MainActor [weak self] in
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
