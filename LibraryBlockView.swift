/*
Purpose: Draws a library item that can be tapped or dragged into the canvas.
MVVM: Receives a BlockKind model and borrows EditorViewModel for styling and actions.
Computed property and actions:
- body draws the kind's title, description, and symbol.
- The button asks viewModel.add(_:) to create a block within an animated change.
- draggable exports the kind's raw string; FlowCanvasView resolves the drop.
Interaction is disabled during execution. There are no separate functions.
*/

import SwiftUI

struct LibraryBlockView: View {
    let kind: BlockKind
    let viewModel: EditorViewModel

    var body: some View {
        Button { withAnimation { viewModel.add(kind) } } label: {
            HStack(spacing: 10) {
                Image(systemName: viewModel.symbol(for: kind))
                    .foregroundStyle(viewModel.color(for: kind))
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 4) {
                    Text(kind.title).font(.subheadline.bold()).foregroundStyle(.white)
                    Text(kind.detail).font(.caption2).foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .background(PlexusTheme.raised)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .draggable(kind.rawValue)
        .disabled(viewModel.isRunning)
    }
}
