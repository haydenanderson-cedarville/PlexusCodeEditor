/*
Purpose: Lists saved projects and links to their editors.
MVVM: Reads projects/errors from the borrowed ProjectLibraryViewModel.
HomeView resolves each project's ID and supplies shared dependencies to ContentView.
Computed property:
- body displays project names, block counts, dates, and an empty/error state.
Each NavigationLink carries the project ID. There are no explicit functions.
*/

import SwiftUI

struct ProjectListView: View {
    let library: ProjectLibraryViewModel
    let settings: SettingsViewModel

    var body: some View {
        List {
            if library.projects.isEmpty {
                Text("No saved projects. Create a project from the home menu.")
                    .foregroundStyle(.secondary)
            }
            ForEach(library.projects) { project in
                NavigationLink(value: project.id) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(project.name).font(.headline)
                        Text("\(project.blocks.count) blocks • \(project.modifiedAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(PlexusTheme.panel)
            }
            if let error = library.errorMessage {
                Text(error).foregroundStyle(.red)
            }
        }
        .scrollContentBackground(.hidden)
        .background(PlexusTheme.background)
        .navigationTitle("Open project")
    }
}
