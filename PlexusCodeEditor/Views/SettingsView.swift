import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("Canvas") {
                Toggle("Show grid", isOn: $viewModel.showsGrid)
            }
            Section("Execution") {
                Stepper("Step interval: \(viewModel.stepDuration.formatted(.number.precision(.fractionLength(2)))) seconds",
                        value: $viewModel.stepDuration, in: 0.25...2, step: 0.05)
            }
            Section("Storage") {
                Text("Projects are saved automatically on this device.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(PlexusTheme.background)
        .navigationTitle("Settings")
    }
}
