/*
Purpose: Owns the grid-visibility and execution-interval preferences.
MVVM: HomeView owns this observable view model; SettingsView binds controls to it,
and EditorViewModel/FlowCanvasView consume the same preferences.
Functions:
- init(defaults:) reads saved preferences and supplies valid defaults.
Observers:
- showsGrid.didSet and stepDuration.didSet persist changes to UserDefaults.
UserDefaults is the small persistence addition needed to retain settings across launches.
*/

import SwiftUI

@MainActor
@Observable
class SettingsViewModel {
    var showsGrid: Bool {
        didSet { defaults.set(showsGrid, forKey: "plexus.showsGrid") }
    }
    var stepDuration: Double {
        didSet { defaults.set(stepDuration, forKey: "plexus.stepDuration") }
    }
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showsGrid = defaults.object(forKey: "plexus.showsGrid") as? Bool ?? true
        let saved = defaults.double(forKey: "plexus.stepDuration")
        stepDuration = (0.25...2).contains(saved) ? saved : 0.65
    }
}
