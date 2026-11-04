import Foundation

struct PlexusProject: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var blocks: [CodeBlock]
    var modifiedAt = Date()
}
