/*
Purpose: Defines the visual grid behind the editable flow.
MVVM: A stateless presentation Shape used by FlowCanvasView; it has no model dependencies.
Function:
- path(in:) draws horizontal and vertical lines every 28 points within the supplied rectangle.
The canvas decides whether to show it using SettingsViewModel.showsGrid.
*/

import SwiftUI

struct GridShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for x in stride(from: rect.minX, through: rect.maxX, by: 28) {
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        for y in stride(from: rect.minY, through: rect.maxY, by: 28) {
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        return path
    }
}
