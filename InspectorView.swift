/*
Purpose: Provides editing controls for the selected block.
MVVM: Uses @Bindable on the borrowed EditorViewModel; its computed selectedValue
and selectedComparison properties update the underlying model and trigger autosave.
Computed property and actions:
- body shows the block details, bound value field, and comparison buttons for IF.
- Comparison buttons assign selectedComparison; Disconnect and Delete call
  disconnectSelected() and deleteSelected() on the shared view model.
Controls are disabled while the program runs. There are no separate functions.
*/

import SwiftUI

struct InspectorView: View {
    @Bindable var viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let block = viewModel.selectedBlock {
                Label(block.title, systemImage: viewModel.symbol(for: block.kind))
                    .font(.headline).foregroundStyle(viewModel.color(for: block.kind))
                Text(block.kind.detail).font(.caption).foregroundStyle(.secondary)
                if block.kind != .start && block.kind != .end {
                    TextField("Value", text: $viewModel.selectedValue)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Block value")
                }
                if block.kind == .condition {
                    HStack(spacing: 6) {
                        ForEach(ComparisonOperator.allCases) { comparison in
                            Button(comparison.rawValue) {
                                viewModel.selectedComparison = comparison
                            }
                            .buttonStyle(.bordered)
                            .tint(viewModel.selectedComparison == comparison ? PlexusTheme.accent : .gray)
                            .accessibilityLabel("Counter \(comparison.rawValue) value")
                            .accessibilityAddTraits(viewModel.selectedComparison == comparison ? .isSelected : [])
                        }
                    }
                    Text("Follow Yes when counter \(viewModel.selectedComparison.rawValue) the value; otherwise follow No.")
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
        .padding(4)
        .disabled(viewModel.isRunning)
    }
}
