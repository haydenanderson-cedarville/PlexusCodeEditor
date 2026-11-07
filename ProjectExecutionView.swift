/*
Purpose: Shows output above a fitted flow overview, or output alone in full-screen mode.
MVVM: Borrows EditorViewModel for both displays. Local @State owns full-screen
presentation; switching modes preserves the same program and running task.
Computed property and actions:
- body measures available height and assigns one third to output and two thirds to flow.
- The Full screen / Show flow chart button toggles local presentation state.
  Full-screen mode hides the navigation toolbar and retains an exit button.
There are no separate functions; the preview supplies an example view model.
*/

import SwiftUI

struct ProjectExecutionView: View {
    let viewModel: EditorViewModel
    let inspect: (CodeBlock) -> Void
    @State private var isProgramFullScreen = false

    var body: some View {
        GeometryReader { geometry in
            let availableHeight = max(0, geometry.size.height - 1)
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    ProgramPreviewView(viewModel: viewModel)
                        .padding(.top, 40)
                    Button(isProgramFullScreen ? "Show flow chart" : "Full screen",
                           systemImage: isProgramFullScreen
                           ? "arrow.down.right.and.arrow.up.left"
                           : "arrow.up.left.and.arrow.down.right") {
                        isProgramFullScreen.toggle()
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .padding(6)
                }
                .background(PlexusTheme.panel)
                .frame(height: isProgramFullScreen ? geometry.size.height : availableHeight / 3)

                if !isProgramFullScreen {
                    Divider().frame(height: 1)
                    FittedFlowView(viewModel: viewModel, inspect: inspect)
                        .frame(height: availableHeight * 2 / 3)
                }
            }
        }
        .toolbar(isProgramFullScreen ? .hidden : .visible, for: .navigationBar)
    }
}

#Preview {
    ProjectExecutionView(viewModel: EditorViewModel(), inspect: { _ in })
        .preferredColorScheme(.dark)
}
