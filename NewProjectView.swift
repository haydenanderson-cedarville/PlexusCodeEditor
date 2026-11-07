/*
Purpose: Collects a project name and optional example-program choice.
MVVM: Borrows ProjectLibraryViewModel and settings; @State owns temporary form inputs
and the newly created project's ID.
Computed property and actions:
- body builds the form and disables creation for blank names or an already-created project.
- Create project calls library.create(name:useExample:) and stores the returned ID.
- Open editor uses value-based navigation handled by HomeView.
Errors are read from the library. There are no separate functions.
*/

import SwiftUI

struct NewProjectView: View {
    let library: ProjectLibraryViewModel
    let settings: SettingsViewModel
    @State private var name = ""
    @State private var useExample = false
    @State private var createdID: UUID?

    var body: some View {
        Form {
            Section("Project") {
                TextField("Project name", text: $name)
                Toggle("Start with example program", isOn: $useExample)
            }
            Section {
                Button("Create project") {
                    createdID = library.create(name: name, useExample: useExample)?.id
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || createdID != nil)
                if let id = createdID {
                    NavigationLink("Open editor", value: id)
                }
            }
            if let error = library.errorMessage {
                Section { Text(error).foregroundStyle(.red) }
            }
        }
        .scrollContentBackground(.hidden)
        .background(PlexusTheme.background)
        .navigationTitle("New project")
    }
}
