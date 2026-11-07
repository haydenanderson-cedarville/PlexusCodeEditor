/*
Purpose: Keeps the editable canvas above a fixed horizontal block library.
MVVM: Borrows EditorViewModel and forwards it to both children; the inspect callback
lets ContentView own inspector presentation.
Computed property:
- body fills available space with FlowCanvasView and places BlockLibraryView below it.
No separate functions or program rules. The preview uses an example view model.
*/

import SwiftUI

struct ProjectEditorView: View {
    let viewModel: EditorViewModel
    let inspect: (CodeBlock) -> Void

    var body: some View {
        VStack(spacing: 0) {
            FlowCanvasView(viewModel: viewModel, inspect: inspect)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Divider()
            BlockLibraryView(viewModel: viewModel)
        }
    }
}

#Preview {
    ProjectEditorView(viewModel: EditorViewModel(), inspect: { _ in })
        .preferredColorScheme(.dark)
}
