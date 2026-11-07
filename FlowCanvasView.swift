/*
Purpose: Provides the pannable, full-size editing canvas and block drop target.
MVVM: Borrows EditorViewModel; forwards inspection to ContentView and sends accepted
drop data to the view model rather than modifying Program directly.
Computed property and callbacks:
- body draws the optional grid, connections, and nodes in canvas coordinates.
- dropDestination passes dropped strings and their canvas positions to acceptDrop(_:at:).
- Cancel clears a pending connection; child blocks handle selection and movement.
There are no separate functions; the scroll view pans within its fixed viewport.
*/

import SwiftUI

struct FlowCanvasView: View {
    let viewModel: EditorViewModel
    let inspect: (CodeBlock) -> Void

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .topLeading) {
                if viewModel.settings.showsGrid {
                    GridShape().stroke(.white.opacity(0.055), lineWidth: 1)
                }
                ForEach(viewModel.blocks) { block in
                    ConnectionView(block: block, viewModel: viewModel)
                }
                ForEach(viewModel.blocks) { block in
                    CodeBlockView(block: block, viewModel: viewModel, inspect: inspect)
                        .position(x: block.x, y: block.y)
                }
            }
            .frame(width: 880, height: 1040)
            .background(PlexusTheme.background)
            .contentShape(Rectangle())
            // The drop location uses the canvas's coordinates, including its scroll offset.
            .dropDestination(for: String.self) { strings, point in
                viewModel.acceptDrop(strings, at: point)
            }
        }
        // Keep the initial Start block visible on narrow screens.
        .defaultScrollAnchor(.top)
        .background(PlexusTheme.background)
        .clipped()
        .overlay(alignment: .bottom) {
            if viewModel.connectionSource != nil {
                HStack {
                    Text("Tap a destination").font(.caption)
                    Button("Cancel") { viewModel.connectionSource = nil }
                }
                .padding(8)
                .background(PlexusTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(6)
            }
        }
    }
}
