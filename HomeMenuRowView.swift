/*
Purpose: Gives home navigation links a consistent icon, title, and chevron.
MVVM: A stateless presentation view configured by HomeView; it owns no view model
because it performs no data operations.
Computed property:
- body renders the supplied title/symbol and chooses prominent or normal styling.
Navigation is supplied by the enclosing NavigationLink. No explicit functions.
*/

import SwiftUI

struct HomeMenuRowView: View {
    let title: String
    let symbol: String
    var prominent = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: symbol).frame(width: 24)
            Text(title).font(.headline)
            Spacer()
            Image(systemName: "chevron.right").font(.caption.bold())
        }
        .foregroundStyle(prominent ? .white : PlexusTheme.accent)
        .padding(20)
        .background(prominent ? PlexusTheme.purple : PlexusTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(PlexusTheme.accent.opacity(0.18)))
    }
}
