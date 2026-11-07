/*
Purpose: Provides a reusable scrolling list of execution messages.
MVVM: Reads Program.log and visited through a borrowed EditorViewModel.
Computed property:
- body displays a step count, an empty-state message, or entries newest first.
This standalone component is retained but is not embedded in the fixed project layouts;
ProgramPreviewView shows the latest entry there. There are no explicit functions.
*/

import SwiftUI

struct ExecutionLogView: View {
    let viewModel: EditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("EXECUTION LOG").font(.caption.monospaced()).foregroundStyle(.secondary)
                Spacer()
                Text("\(viewModel.program.visited.count) steps").font(.caption2)
            }
            if viewModel.program.log.isEmpty {
                Text("Press Run or Step. Your program's story appears here.")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.program.log.reversed()) { entry in
                            Text("› \(entry.text)")
                                .font(.caption.monospaced())
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(height: 150)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .plexusPanel()
    }
}
