/*
Purpose: Supplies the project's navigation-toolbar controls.
MVVM: Borrows EditorViewModel for execution commands and a @Binding to the
layout state owned by ContentView.
Computed property and actions:
- body creates Edit, Run/Stop, Step, and Reset controls.
- Edit stops execution and changes the parent layout back to editing.
- Run enters the execution layout and calls run(); Stop calls stop().
- Step enters the execution layout and calls step() inside withAnimation.
- Reset calls reset() without changing layout. Step is disabled during a run.
There are no separate functions.
*/

import SwiftUI

// Shared controls are placed in the project's navigation toolbar.
struct EditorHeaderView: View {
    let viewModel: EditorViewModel
    @Binding var showingExecution: Bool

    var body: some View {
        if showingExecution {
            Button("Edit", systemImage: "pencil") {
                viewModel.stop()
                showingExecution = false
            }
        }
        Button(viewModel.isRunning ? "Stop" : "Run",
               systemImage: viewModel.isRunning ? "stop.fill" : "play.fill") {
            if viewModel.isRunning {
                viewModel.stop()
            } else {
                showingExecution = true
                viewModel.run()
            }
        }
        Button("Step", systemImage: "forward.end") {
            showingExecution = true
            withAnimation { viewModel.step() }
        }
        .disabled(viewModel.isRunning)
        Button("Reset", systemImage: "arrow.counterclockwise") {
            viewModel.reset()
        }
    }
}
