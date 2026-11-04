import SwiftUI

struct ProgramPreviewView: View {
    let viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("03  PROGRAM VIEW").font(.caption.monospaced()).foregroundStyle(.secondary)
                Spacer()
                Circle().fill(PlexusTheme.accent).frame(width: 6, height: 6)
            }
            VStack(spacing: 22) {
                Text(viewModel.program.message)
                    .font(.headline).multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 44)
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(viewModel.stageColor.gradient)
                        .frame(width: 68, height: 68)
                    HStack(spacing: 16) {
                        Capsule().fill(PlexusTheme.background).frame(width: 5, height: 13)
                        Capsule().fill(PlexusTheme.background).frame(width: 5, height: 13)
                    }
                }
                .offset(x: viewModel.program.characterX)
                .animation(.spring, value: viewModel.program.characterX)
                .animation(.easeInOut, value: viewModel.program.characterColor)
                Rectangle().fill(.white.opacity(0.12)).frame(height: 1)
                HStack {
                    Text("counter").foregroundStyle(.secondary)
                    Spacer()
                    Text("\(viewModel.program.counter)").foregroundStyle(PlexusTheme.accent)
                }
                .font(.subheadline.monospaced())
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(PlexusTheme.background)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .plexusPanel()
    }
}
