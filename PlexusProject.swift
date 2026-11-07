/*
Purpose: Represents a saved project: ID, name, blocks, and modification date.
MVVM: Model exchanged between ProjectLibraryViewModel and EditorViewModel.
Functions: No explicit functions. Swift supplies the memberwise initializer,
equality, and Codable encoding/decoding. Runtime output is intentionally not saved.
*/

import Foundation

struct PlexusProject: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var blocks: [CodeBlock]
    var modifiedAt = Date()
}
