/*
Purpose: Loads, creates, and saves the local project library.
MVVM: HomeView owns this observable view model; project screens read its projects
and errors. EditorViewModel delegates autosave here using PlexusProject models.
Functions:
- init(directory:) chooses the supplied directory or app Documents folder and calls load().
- load() creates the directory, decodes project JSON files, sorts by modification date,
  and reports unreadable files without deleting them.
- create(name:useExample:) rejects blank names, builds a new or example project,
  saves it, and returns the project only if saving succeeds.
- save(_:) atomically writes JSON, updates/sorts the published list, and returns success.
Persistence uses Foundation file APIs beyond the course's in-memory examples.
*/

import SwiftUI

@MainActor
@Observable
class ProjectLibraryViewModel {
    private(set) var projects: [PlexusProject] = []
    var errorMessage: String?
    private let directory: URL

    init(directory: URL? = nil) {
        self.directory = directory ?? URL.documentsDirectory.appending(path: "PlexusProjects")
        load()
    }

    func load() {
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let urls = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            var loaded: [PlexusProject] = []
            for url in urls where url.pathExtension == "json" {
                do {
                    loaded.append(try JSONDecoder().decode(PlexusProject.self, from: Data(contentsOf: url)))
                } catch {
                    errorMessage = "Could not open \(url.lastPathComponent). The saved file has been kept."
                }
            }
            projects = loaded.sorted { $0.modifiedAt > $1.modifiedAt }
        } catch {
            errorMessage = "Could not read projects: \(error.localizedDescription)"
        }
    }

    func create(name: String, useExample: Bool) -> PlexusProject? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let blocks = useExample ? Program.example.blocks : [
            CodeBlock(kind: .start, value: "", x: 360, y: 85)
        ]
        let project = PlexusProject(name: trimmed, blocks: blocks)
        return save(project) ? project : nil
    }

    @discardableResult
    func save(_ project: PlexusProject) -> Bool {
        do {
            let data = try JSONEncoder().encode(project)
            try data.write(to: directory.appending(path: "\(project.id.uuidString).json"), options: .atomic)
            projects.removeAll { $0.id == project.id }
            projects.append(project)
            projects.sort { $0.modifiedAt > $1.modifiedAt }
            errorMessage = nil
            return true
        } catch {
            errorMessage = "Could not save \(project.name): \(error.localizedDescription)"
            return false
        }
    }
}
