/*
Purpose: Provides instructions for building, connecting, editing, and running blocks.
MVVM: Static help content describing actions handled by EditorViewModel; it does
not own or mutate a Program.
Computed property:
- body builds a scrollable guide inside a NavigationStack suitable for a sheet.
There are no explicit functions.
*/

import SwiftUI

struct GuideView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Editor guide").font(.largeTitle.bold())
                    Text("1. Build").font(.headline).foregroundStyle(PlexusTheme.accent)
                    Text("Drag a block from the library onto the canvas, or tap to add it. Drag blocks on the canvas to arrange your flow.")
                    Text("2. Connect").font(.headline).foregroundStyle(PlexusTheme.accent)
                    Text("Tap Connect on a block, then tap its destination. An If block has Yes and No outputs. Connecting again replaces that output.")
                    Text("3. Edit values").font(.headline).foregroundStyle(PlexusTheme.accent)
                    Text("Double-tap a block to open its inspector and edit its value. Numbers control the counter or horizontal movement. Colors are mint, blue and pink.")
                    Text("4. Execute").font(.headline).foregroundStyle(PlexusTheme.accent)
                    Text("Run follows your connections from Start. Step executes one block at a time. Run and Step show program output above the flow chart. Edit returns to the bottom block library. Reset clears execution while keeping your blocks.")
                    Text("Try changing the example's Set counter value from 3 to 1 and run it again to see the other branch.")
                    Text("Projects save automatically on this device. Create or open projects from the home menu.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding(24)
            }
            .background(PlexusTheme.background)
            .navigationTitle("Welcome to Plexus")
        }
        .preferredColorScheme(.dark)
    }
}
