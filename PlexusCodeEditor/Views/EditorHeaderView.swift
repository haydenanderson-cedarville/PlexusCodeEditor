import SwiftUI

struct EditorHeaderView: View {
    let viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let error = viewModel.saveError {
                Text(error).font(.caption).foregroundStyle(.red)
                Button("Retry save") { viewModel.saveProject() }
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    Button(viewModel.isRunning ? "Stop" : "Run", systemImage: viewModel.isRunning ? "stop.fill" : "play.fill") {
                        if viewModel.isRunning { viewModel.stop() } else { viewModel.run() }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.black)
                    Button("Step", systemImage: "forward.end") { withAnimation { viewModel.step() } }
                        .disabled(viewModel.isRunning)
                    Button("Reset", systemImage: "arrow.counterclockwise") { viewModel.reset() }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
