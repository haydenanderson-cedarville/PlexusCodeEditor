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
