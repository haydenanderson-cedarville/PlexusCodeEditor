/*
Purpose: Hosts an open project, switching between editing and execution layouts.
MVVM: Owns EditorViewModel with @State and passes that shared instance to child
views. Local @State owns layout and inspector visibility, not program rules.
Functions and computed properties:
- init(project:library:settings:) constructs the editor view model from the selected project.
- body presents the selected layout, navigation controls, save errors, and inspector sheet.
  Done dismisses the inspector; onDisappear stops execution and saves the project.
- inspect(_:) ignores inspection during execution, clears pending connections, selects
  the block in the view model, and opens the inspector.
The example #Preview supplies a sample model, temporary library, and navigation stack.
*/

import SwiftUI

struct ContentView: View {
    @State private var viewModel: EditorViewModel
    @State private var showingExecution = false
    @State private var showingInspector = false

    init(project: PlexusProject, library: ProjectLibraryViewModel, settings: SettingsViewModel) {
        _viewModel = State(initialValue: EditorViewModel(project: project, library: library, settings: settings))
    }

    var body: some View {
        VStack(spacing: 0) {
            if let error = viewModel.saveError {
                HStack {
                    Text(error).font(.caption)
                    Button("Retry save") { viewModel.saveProject() }
                }
                .padding(6)
            }
            if showingExecution {
                ProjectExecutionView(viewModel: viewModel, inspect: inspect)
            } else {
                ProjectEditorView(viewModel: viewModel, inspect: inspect)
            }
        }
        .background(PlexusTheme.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                EditorHeaderView(viewModel: viewModel, showingExecution: $showingExecution)
            }
        }
        .sheet(isPresented: $showingInspector) {
            VStack(alignment: .trailing, spacing: 8) {
                Button("Done") { showingInspector = false }
                InspectorView(viewModel: viewModel)
                Spacer(minLength: 0)
            }
            .padding(12)
            .background(PlexusTheme.panel)
            .presentationDetents([.medium, .large])
        }
        .preferredColorScheme(.dark)
        .tint(PlexusTheme.accent)
        .onDisappear {
            viewModel.stop()
            viewModel.saveProject()
        }
    }

    private func inspect(_ block: CodeBlock) {
        guard !viewModel.isRunning else { return }
        viewModel.connectionSource = nil
        viewModel.selectedID = block.id
        showingInspector = true
    }
}

#Preview("Example project") {
    let project = PlexusProject(name: "Example", blocks: Program.example.blocks)
    let library = ProjectLibraryViewModel(
        directory: URL.temporaryDirectory.appending(path: "PlexusPreview")
    )

    NavigationStack {
        ContentView(project: project, library: library, settings: SettingsViewModel())
    }
}
