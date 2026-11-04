import SwiftUI

struct FlowCanvasView: View {
    let viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("02  FLOW CANVAS").font(.caption.monospaced()).foregroundStyle(.secondary)
                Spacer()
                Text("\(viewModel.blocks.count) blocks").font(.caption).foregroundStyle(.secondary)
            }
            HStack {
                Text(viewModel.status).font(.caption).foregroundStyle(.secondary)
                if viewModel.connectionSource != nil {
                    Button("Cancel") { viewModel.connectionSource = nil }
                }
            }
            ScrollView([.horizontal, .vertical]) {
                ZStack(alignment: .topLeading) {
                    if viewModel.settings.showsGrid {
                        GridShape().stroke(.white.opacity(0.055), lineWidth: 1)
                    }
                    ForEach(viewModel.blocks) { block in
                        ConnectionView(block: block, viewModel: viewModel)
                    }
                    ForEach(viewModel.blocks) { block in
                        CodeBlockView(block: block, viewModel: viewModel)
                            .position(x: block.x, y: block.y)
                    }
                }
                .frame(width: 880, height: 1040)
                .background(PlexusTheme.background)
                .contentShape(Rectangle())
                .dropDestination(for: String.self) { strings, point in
                    viewModel.acceptDrop(strings, at: point)
                }
            }
            .frame(height: 720)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Text("Connect an output → tap a destination  ·  Drag a block to move it")
                .font(.caption2).foregroundStyle(.secondary)
        }
        .plexusPanel()
    }
}
