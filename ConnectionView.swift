/*
Purpose: Draws outgoing graph connections and execution highlighting.
MVVM: Reads a CodeBlock and destinations/execution state from EditorViewModel.
Functions and computed properties:
- body creates paths for next and otherwise destinations when those blocks exist.
- wire(to:alternate:) draws an orthogonal line and arrowhead between node ports,
  choosing normal/alternate colors and highlighting an active destination.
This view is visual only and does not handle touches or change connections.
*/

import SwiftUI

struct ConnectionView: View {
    let block: CodeBlock
    let viewModel: EditorViewModel

    var body: some View {
        Group {
            if let next = viewModel.blocks.first(where: { $0.id == block.next }) {
                wire(to: next, alternate: false)
            }
            if let next = viewModel.blocks.first(where: { $0.id == block.otherwise }) {
                wire(to: next, alternate: true)
            }
        }
        .allowsHitTesting(false)
    }

    private func wire(to destination: CodeBlock, alternate: Bool) -> some View {
        let start = CGPoint(x: block.x + (block.kind == .condition ? (alternate ? 48 : -48) : 0), y: block.y + 49)
        let end = CGPoint(x: destination.x, y: destination.y - 49)
        let active = viewModel.program.activeID == destination.id && viewModel.program.visited.contains(block.id)
        return Path { path in
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x, y: (start.y + end.y) / 2))
            path.addLine(to: CGPoint(x: end.x, y: (start.y + end.y) / 2))
            path.addLine(to: end)
            path.move(to: CGPoint(x: end.x - 5, y: end.y - 7))
            path.addLine(to: end)
            path.addLine(to: CGPoint(x: end.x + 5, y: end.y - 7))
        }
        .stroke(active ? PlexusTheme.accent : (alternate ? Color.orange.opacity(0.6) : PlexusTheme.accent.opacity(0.5)),
                style: StrokeStyle(lineWidth: active ? 3 : 2, lineCap: .round, lineJoin: .round))
    }
}
