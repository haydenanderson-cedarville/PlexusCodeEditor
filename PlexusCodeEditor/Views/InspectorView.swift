import SwiftUI

struct InspectorView: View {
    @Bindable var viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("BLOCK INSPECTOR").font(.caption.monospaced()).foregroundStyle(.secondary)
            if let block = viewModel.selectedBlock {
                Label(block.kind.title, systemImage: viewModel.symbol(for: block.kind))
                    .font(.headline).foregroundStyle(viewModel.color(for: block.kind))
                Text(block.kind.detail).font(.caption).foregroundStyle(.secondary)
                if block.kind != .start && block.kind != .end {
                    TextField("Value", text: $viewModel.selectedValue)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Block value")
                }
                if block.kind == .condition {
                    Text("Yes when counter is at least this number; otherwise follow No.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Button("Disconnect outputs", systemImage: "link.badge.plus") { viewModel.disconnectSelected() }
                Button("Delete block", systemImage: "trash", role: .destructive) { viewModel.deleteSelected() }
            } else {
                Image(systemName: "slider.horizontal.3").font(.title).foregroundStyle(.secondary)
                Text("Select any block to edit its value or connections.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .plexusPanel()
        .disabled(viewModel.isRunning)
    }
}
