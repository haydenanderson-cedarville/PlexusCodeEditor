/*
Purpose: Displays the entire project graph at a scale that fits the execution area.
MVVM: Borrows EditorViewModel's blocks, flowBounds, and flowScale(in:); child node
and connection views observe the same execution state.
Computed property:
- body translates nodes/connections to the bounding-box origin, scales the drawing,
  reserves its scaled size, and centers it in the available area.
Hit testing is disabled for this overview; editing occurs in FlowCanvasView.
The inspect callback is forwarded to reused node views but is inactive here.
*/

import SwiftUI

struct FittedFlowView: View {
    let viewModel: EditorViewModel
    let inspect: (CodeBlock) -> Void

    var body: some View {
        GeometryReader { geometry in
            let bounds = viewModel.flowBounds
            let scale = viewModel.flowScale(in: geometry.size)

            ZStack(alignment: .topLeading) {
                ForEach(viewModel.blocks) { block in
                    ConnectionView(block: block, viewModel: viewModel)
                        .offset(x: -bounds.minX, y: -bounds.minY)
                }
                ForEach(viewModel.blocks) { block in
                    CodeBlockView(block: block, viewModel: viewModel, inspect: inspect)
                        .position(x: block.x - bounds.minX, y: block.y - bounds.minY)
                }
            }
            .frame(width: bounds.width, height: bounds.height)
            .scaleEffect(scale, anchor: .topLeading)
            // scaleEffect changes drawing, so reserve its scaled layout size too.
            .frame(width: bounds.width * scale, height: bounds.height * scale, alignment: .topLeading)
            .frame(width: geometry.size.width, height: geometry.size.height)
            // Editing is done at full size; this overview follows execution only.
            .allowsHitTesting(false)
        }
        .background(PlexusTheme.background)
        .clipped()
    }
}
