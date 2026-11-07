/*
Purpose: Draws one block with its value, outputs, selection, and execution highlight.
MVVM: Receives a CodeBlock snapshot and borrows the shared EditorViewModel.
User actions ask that view model to modify the graph; they never mutate the snapshot.
Computed property and gesture callbacks:
- body draws the card using view-model colors/symbols and model title/value.
- Output buttons call beginConnection(_:otherwise:); single-tap calls select(_:).
- Double-tap and the accessibility inspection action invoke the parent inspect callback.
- DragGesture.updating stores temporary translation in @GestureState; onEnded calls move(_:by:).
- Accessibility selection invokes the same select(_:) action.
There are no separate functions. Gesture state resets automatically after dragging.
*/

import SwiftUI

struct CodeBlockView: View {
    let block: CodeBlock
    let viewModel: EditorViewModel
    let inspect: (CodeBlock) -> Void
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: viewModel.symbol(for: block.kind))
                    .foregroundStyle(viewModel.color(for: block.kind))
                Text(block.title).font(.subheadline.bold())
                Spacer(minLength: 0)
                if viewModel.program.activeID == block.id {
                    Circle().fill(PlexusTheme.accent).frame(width: 7, height: 7)
                }
            }
            Text(block.value.isEmpty ? block.kind.detail : block.value)
                .font(.caption.monospaced()).foregroundStyle(.secondary).lineLimit(1)
            if block.kind != .end {
                HStack {
                    Button(block.kind == .condition ? "Yes ↘" : "Connect ↓") {
                        viewModel.beginConnection(block)
                    }
                    Spacer()
                    if block.kind == .condition {
                        Button("No ↘") { viewModel.beginConnection(block, otherwise: true) }
                            .tint(.orange)
                    }
                }
                .font(.caption2.bold())
                .buttonStyle(.plain)
                .foregroundStyle(viewModel.color(for: block.kind))
            }
        }
        .padding(12)
        .frame(width: 200, height: 100)
        .background(PlexusTheme.raised)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(viewModel.selectedID == block.id || viewModel.program.activeID == block.id
                        ? viewModel.color(for: block.kind) : .white.opacity(0.14), lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
        .offset(dragOffset)
        .onTapGesture(count: 2) { inspect(block) }
        .onTapGesture { viewModel.select(block) }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    if !viewModel.isRunning { state = value.translation }
                }
                .onEnded { value in viewModel.move(block, by: value.translation) }
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(block.title), \(block.value)")
        .accessibilityAction(named: "Inspect block") { inspect(block) }
        .accessibilityAction(named: "Select block") { viewModel.select(block) }
    }
}
