import SwiftUI

struct ContentView: View {
    @State private var viewModel: EditorViewModel

    init(project: PlexusProject, library: ProjectLibraryViewModel, settings: SettingsViewModel) {
        _viewModel = State(initialValue: EditorViewModel(project: project, library: library, settings: settings))
    }
    @State private var showingHelp = false

    var body: some View {
        Group {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        EditorHeaderView(viewModel: viewModel)
                        if geometry.size.width > 1050 {
                            HStack(alignment: .top, spacing: 18) {
                                BlockLibraryView(viewModel: viewModel).frame(width: 210)
                                FlowCanvasView(viewModel: viewModel).frame(maxWidth: .infinity)
                                VStack(spacing: 18) {
                                    ProgramPreviewView(viewModel: viewModel)
                                    InspectorView(viewModel: viewModel)
                                    ExecutionLogView(viewModel: viewModel)
                                }
                                .frame(width: 280)
                            }
                        } else {
                            ProgramPreviewView(viewModel: viewModel)
                            BlockLibraryView(viewModel: viewModel)
                            FlowCanvasView(viewModel: viewModel)
                            InspectorView(viewModel: viewModel)
                            ExecutionLogView(viewModel: viewModel)
                        }
                    }
                    .padding(geometry.size.width > 600 ? 24 : 14)
                }
                .background(PlexusTheme.background)
            }
            .navigationTitle(viewModel.projectName)
            .toolbar {
                Button("Guide", systemImage: "questionmark.circle") { showingHelp = true }
            }
            .sheet(isPresented: $showingHelp) { GuideView() }
        }
        .preferredColorScheme(.dark)
        .tint(PlexusTheme.accent)
        .onDisappear { viewModel.stop(); viewModel.saveProject() }
    }
}

