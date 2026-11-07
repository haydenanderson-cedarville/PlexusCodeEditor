/*
Purpose: Draws program output: message, character, counter, and latest execution entry.
MVVM: Reads Program state and stageColor through the borrowed EditorViewModel.
Computed property:
- body sizes the character to available height and animates changes in its position/color.
It displays the model's results without executing instructions or changing game state.
There are no explicit functions.
*/

import SwiftUI

struct ProgramPreviewView: View {
    let viewModel: EditorViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 6) {
                Text(viewModel.program.message)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity)
                Spacer(minLength: 0)
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(viewModel.stageColor.gradient)
                    HStack(spacing: 16) {
                        Capsule().fill(PlexusTheme.background).frame(width: 5, height: 13)
                        Capsule().fill(PlexusTheme.background).frame(width: 5, height: 13)
                    }
                }
                .frame(width: min(68, geometry.size.height * 0.3),
                       height: min(68, geometry.size.height * 0.3))
                .offset(x: viewModel.program.characterX)
                .animation(.spring, value: viewModel.program.characterX)
                .animation(.easeInOut, value: viewModel.program.characterColor)
                Spacer(minLength: 0)
                HStack {
                    Text("Counter: \(viewModel.program.counter)")
                    Spacer()
                    if let entry = viewModel.program.log.last {
                        Text(entry.text).lineLimit(2)
                    }
                }
                .font(.caption.monospaced())
                .foregroundStyle(PlexusTheme.accent)
            }
            .padding(8)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(PlexusTheme.panel)
        .clipped()
    }
}
