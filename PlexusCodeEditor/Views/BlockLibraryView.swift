import SwiftUI

struct BlockLibraryView: View {
    let viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("01  BLOCK LIBRARY").font(.caption.monospaced()).foregroundStyle(.secondary)
            Text("Drag onto the canvas or tap to add.").font(.caption).foregroundStyle(.secondary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))], spacing: 10) {
                ForEach(BlockKind.allCases) { kind in
                    LibraryBlockView(kind: kind, viewModel: viewModel)
                }
            }
        }
        .plexusPanel()
    }
}
