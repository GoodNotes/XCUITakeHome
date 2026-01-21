//
//  ContentView.swift
//  TodoListApp
//
//  Main content view with adaptive layout for all platforms
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var showingAddTask = false
    @State private var selectedTask: TodoTask?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        #if os(iOS)
        iOSContent
        #else
        macOSLayout
        #endif
    }
    
    // MARK: - iOS Content (iPhone vs iPad)
    #if os(iOS)
    @ViewBuilder
    private var iOSContent: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            iPadLayout
        } else {
            iPhoneLayout
        }
    }
    
    // MARK: - iPhone Layout
    private var iPhoneLayout: some View {
        NavigationStack {
            TaskListView(selectedTask: $selectedTask)
                .navigationTitle(taskStore.selectedList.rawValue)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            ForEach(TaskList.allCases) { list in
                                Button {
                                    taskStore.selectedList = list
                                } label: {
                                    Label(list.rawValue, systemImage: list.iconName)
                                }
                            }
                        } label: {
                            Label("Lists", systemImage: "list.bullet")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddTask = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                        .accessibilityIdentifier("addTaskButton")
                    }
                }
                .searchable(text: $taskStore.searchText, prompt: "Search tasks")
                .sheet(isPresented: $showingAddTask) {
                    AddTaskView()
                }
                .navigationDestination(item: $selectedTask) { task in
                    TaskDetailView(task: task)
                }
        }
    }
    
    // MARK: - iPad Layout
    private var iPadLayout: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(onAddTask: {
                showingAddTask = true
            })
        } content: {
            TaskListView(selectedTask: $selectedTask)
                .navigationTitle(taskStore.selectedList.rawValue)
                .searchable(text: $taskStore.searchText, prompt: "Search tasks")
        } detail: {
            if let task = selectedTask {
                TaskDetailView(task: task)
            } else {
                ContentUnavailableView(
                    "No Task Selected",
                    systemImage: "checklist",
                    description: Text("Select a task to view details")
                )
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
    }
    #endif
    
    // MARK: - macOS Layout
    #if os(macOS)
    private var macOSLayout: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(onAddTask: {
                showingAddTask = true
            })
                .frame(minWidth: 200)
        } content: {
            TaskListView(selectedTask: $selectedTask)
                .navigationTitle(taskStore.selectedList.rawValue)
                .frame(minWidth: 300)
                .searchable(text: $taskStore.searchText, prompt: "Search tasks")
        } detail: {
            if let task = selectedTask {
                TaskDetailView(task: task)
                    .frame(minWidth: 400)
            } else {
                ContentUnavailableView(
                    "No Task Selected",
                    systemImage: "checklist",
                    description: Text("Select a task to view details")
                )
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
                .frame(minWidth: 450, minHeight: 400)
        }
    }
    #endif
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(TaskStore())
}
