/*
Purpose: Shows available block kinds in a fixed bottom horizontal shelf.
MVVM: Borrows EditorViewModel and passes it with each BlockKind to LibraryBlockView.
Computed property:
- body builds a horizontal ScrollView/HStack using stable BlockKind identities.
There are no explicit functions; adding and dragging are handled by the child views.
*/

import SwiftUI

struct BlockLibraryView: View {
    let viewModel: EditorViewModel

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(BlockKind.allCases) { kind in
                    LibraryBlockView(kind: kind, viewModel: viewModel)
                        .frame(width: 180)
                }
            }
            .padding(8)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(PlexusTheme.panel)
    }
}
