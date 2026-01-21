//
//  SidebarView.swift
//  TodoListApp
//
//  Sidebar navigation for iPad and macOS
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var taskStore: TaskStore
    var onAddTask: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(TaskList.allCases) { list in
                        Button {
                            taskStore.selectedList = list
                        } label: {
                            SidebarRow(list: list, count: taskStore.taskCounts[list] ?? 0)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(
                            taskStore.selectedList == list
                                ? Color.accentColor.opacity(0.2)
                                : Color.clear
                        )
                        .accessibilityIdentifier("sidebar_\(list.rawValue)")
                    }
                } header: {
                    Text("My Lists")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.sidebar)
            
            // Add Task button at bottom of sidebar - always visible and accessible
            if let onAddTask = onAddTask {
                Divider()
                Button {
                    onAddTask()
                } label: {
                    Label("Add Task", systemImage: "plus.circle.fill")
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #else
                .buttonStyle(.borderless)
                #endif
                .accessibilityIdentifier("addTaskButton")
            }
        }
        .navigationTitle("Reminders")
        #if os(macOS)
        .frame(minWidth: 200)
        #endif
    }
}

// MARK: - Sidebar Row
struct SidebarRow: View {
    let list: TaskList
    let count: Int
    
    var body: some View {
        HStack {
            Image(systemName: list.iconName)
                .font(.title3)
                .foregroundStyle(listColor)
                .frame(width: 28)
            
            Text(list.rawValue)
                .font(.body)
            
            Spacer()
            
            if count > 0 {
                Text("\(count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
    
    private var listColor: Color {
        switch list.color {
        case "blue": return .blue
        case "red": return .red
        case "orange": return .orange
        case "gray": return .gray
        default: return .blue
        }
    }
}

#Preview {
    NavigationStack {
        SidebarView(onAddTask: {})
            .environmentObject(TaskStore())
    }
}

