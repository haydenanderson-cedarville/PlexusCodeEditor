/*
Purpose: Provides controls for grid visibility and execution timing.
MVVM: @Bindable borrows SettingsViewModel so controls write through to the shared
preferences; the view model's observers persist changes.
Computed property:
- body builds a Toggle bound to showsGrid and a Stepper bound to stepDuration,
  with its allowed range, plus local-storage information.
There are no explicit functions.
*/

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
