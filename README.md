# Plexus

A SwiftUI visual programming workspace based on the supplied ITM 3300 slides and Plexus project brief.

Run the app in Xcode. The home menu opens New project, Open project, Settings, and About. To try the example, enable “Start with example program” when creating a project. Change its Set counter block to 1 to take the other path.

## Using the editor

- Drag library blocks onto the canvas or tap to add them.
- Drag a canvas block to reposition it.
- Tap Connect (or Yes/No), then tap a destination block.
- Select a block to edit its value, disconnect its outputs, or delete it.
- Run animates execution; Step executes one block; Reset clears runtime state.
- Create a named project, then choose Open editor. Open project lists projects saved on this device.
- Block edits save automatically, including values, positions, and connections. Execution state resets when reopening.
- Settings control grid visibility and the time between execution steps; these preferences persist across launches.

## Course patterns

Models contain data and execution rules and import only Foundation. EditorViewModel is the shared @Observable translator, owned with @State by ContentView and borrowed by child views. InspectorView uses @Bindable. Every view has its own Swift file. Layout, shapes, gestures, drag and drop, and animations follow the techniques in the slides.

Navigation follows Week 10: NavigationStack, NavigationLink, and value-based navigationDestination. Settings follow Week 11: Form, Toggle, Stepper, and @Bindable. Autosave is triggered by a didSet observer, as introduced in Week 6. Views remain separate files, borrowing shared view models as in Weeks 5–6.

Necessary additions beyond the slides:

- Codable, JSONEncoder/JSONDecoder, FileManager, and atomic Data writes preserve named projects across launches. UUIDs are decoded unchanged so connections remain valid. Each project has its own JSON file in the app's Documents/PlexusProjects folder.
- UserDefaults preserves the two settings across launches.
- Task.sleep spaces execution steps without blocking the interface; @MainActor keeps observable state changes on the UI thread.
- The connected-block interpreter, coordinate limits, and input validation implement the project's specific behavior using the slides' structs, enums, arrays, functions, switches, and guards.

Plexus executes its eight built-in block types, not arbitrary Swift source code. No external libraries are used.

Views are in Views/, program types in Models/, view models in ViewModels/, and reusable presentation styling in Styling/. The supplied logo is stored unchanged in Assets.xcassets/PlexusLogo.imageset. The purple and lavender theme is defined in PlexusTheme.swift; remaining artwork uses SwiftUI shapes and SF Symbols.

## Verification

Xcode BuildProject succeeded. Xcode code snippets verified both condition branches, invalid numeric input, the 200-step execution limit, arithmetic, movement, color, message, finish, and reset. The iPhone preview rendered successfully. Touch interactions have not been exercised in a simulator.

The home-menu update also passed checks for project creation, autosave, reload, stable block IDs, execution through restored connections, and blank-name rejection. The branded home preview rendered successfully.
