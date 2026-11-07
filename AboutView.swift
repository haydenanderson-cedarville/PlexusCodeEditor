/*
Purpose: Explains Plexus, its supported behavior, and local storage.
MVVM: Static presentation content; no mutable data or view model is needed.
Computed property:
- body lays out the explanatory text in a scrollable page.
There are no explicit functions or program actions.
*/

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Plexus").font(.largeTitle.bold())
                Text("A visual code editor for learning how programs work.")
                Text("Build a program by connecting blocks in a branching flow. Blocks can display messages, change a counter, make decisions, and control a character in the program preview.")
                Text("Run follows the connections and highlights each step. Step lets you inspect one operation at a time.")
                Text("Plexus was developed as a mobile application development project using SwiftUI and the Model–View–ViewModel architecture.")
                Text("Projects are stored locally on this device. Plexus executes its built-in blocks; it does not compile arbitrary source code.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 640, alignment: .leading)
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .background(PlexusTheme.background)
        .navigationTitle("About")
    }
}
