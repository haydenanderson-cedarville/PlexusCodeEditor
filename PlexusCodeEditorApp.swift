/*
Purpose: Provides the application's @main entry point.
MVVM: Creates HomeView; that view establishes ownership of shared view models.
Computed property:
- body creates a WindowGroup whose root is HomeView.
There are no explicit functions or game rules in this file.
*/

//
//  PlexusCodeEditorApp.swift
//  PlexusCodeEditor
//
//  Created by Hayden Anderson on 11/4/26.
//

import SwiftUI

@main
struct PlexusCodeEditorApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
