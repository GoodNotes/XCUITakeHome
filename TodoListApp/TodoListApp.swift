//
//  TodoListApp.swift
//  TodoListApp
//
//  A Reminders-style to-do list app for iOS, iPadOS, and macOS
//

import SwiftUI

@main
struct TodoListApp: App {
    @StateObject private var taskStore = TaskStore()
    
    var body: some Scene {
        mainWindow
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
    
    // Separate the WindowGroup to avoid #if issues in Scene builder
    private var mainWindow: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskStore)
        }
        #if os(macOS)
        .defaultSize(width: 900, height: 600)
        #endif
    }
}

// MARK: - Settings View for macOS
#if os(macOS)
struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
        }
        .frame(width: 400, height: 200)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("showCompletedTasks") private var showCompletedTasks = true
    
    var body: some View {
        Form {
            Toggle("Show completed tasks", isOn: $showCompletedTasks)
        }
        .padding()
    }
}
#endif
