import SwiftUI

struct HomeView: View {
    @State private var library = ProjectLibraryViewModel()
    @State private var settings = SettingsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    Image("PlexusLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 520)
                        .accessibilityLabel("Plexus")
                    VStack(spacing: 12) {
                        NavigationLink {
                            NewProjectView(library: library, settings: settings)
                        } label: {
                            HomeMenuRowView(title: "New project", symbol: "plus", prominent: true)
                        }
                        NavigationLink {
                            ProjectListView(library: library, settings: settings)
                        } label: {
                            HomeMenuRowView(title: "Open project", symbol: "folder")
                        }
                        NavigationLink {
                            SettingsView(viewModel: settings)
                        } label: {
                            HomeMenuRowView(title: "Settings", symbol: "gearshape")
                        }
                        NavigationLink {
                            AboutView()
                        } label: {
                            HomeMenuRowView(title: "About", symbol: "info.circle")
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: 440)
                }
                .frame(maxWidth: .infinity)
                .padding(28)
                .padding(.top, 36)
            }
            .background(PlexusTheme.background)
            .navigationTitle("")
            .navigationDestination(for: UUID.self) { id in
                if let project = library.projects.first(where: { $0.id == id }) {
                    ContentView(project: project, library: library, settings: settings)
                } else {
                    Text("Project unavailable.")
                }
            }
        }
        .preferredColorScheme(.dark)
        .tint(PlexusTheme.accent)
    }
}

#Preview {
    HomeView()
}
