/*
Purpose: Centralizes the purple palette and reusable panel styling.
MVVM: Presentation-only helpers shared by views; no model state or program rules.
Functions:
- PanelModifier.body(content:) wraps content in padding, a panel background,
  rounded corners, and a subtle border.
- View.plexusPanel() applies PanelModifier using the course's modifier/extension pattern.
PlexusTheme's static colors are shared visual constants.
*/

import SwiftUI

enum PlexusTheme {
    static let purple = Color(red: 0.43, green: 0.12, blue: 0.85)
    static let background = Color(red: 0.045, green: 0.028, blue: 0.075)
    static let panel = Color(red: 0.095, green: 0.065, blue: 0.14)
    static let raised = Color(red: 0.15, green: 0.10, blue: 0.21)
    static let accent = Color(red: 0.77, green: 0.57, blue: 1.0)
}

struct PanelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(PlexusTheme.panel)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.08)))
    }
}

extension View {
    func plexusPanel() -> some View { modifier(PanelModifier()) }
}
