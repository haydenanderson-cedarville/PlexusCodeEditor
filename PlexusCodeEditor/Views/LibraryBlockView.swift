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
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
            .background(PlexusTheme.raised)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .draggable(kind.rawValue)
        .disabled(viewModel.isRunning)
    }
}
