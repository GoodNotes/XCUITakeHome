//
//  TaskListView.swift
//  TodoListApp
//
//  List view displaying tasks
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskStore: TaskStore
    @Binding var selectedTask: TodoTask?
    
    var body: some View {
        Group {
            if taskStore.filteredTasks.isEmpty {
                emptyStateView
            } else {
                taskList
            }
        }
        .accessibilityIdentifier("taskListView")
    }
    
    // MARK: - Task List
    private var taskList: some View {
        List(selection: $selectedTask) {
            ForEach(taskStore.filteredTasks) { task in
                TaskRowView(task: task, onTap: {
                    selectedTask = task
                })
                    .tag(task)
                    .accessibilityIdentifier("taskRow_\(task.id.uuidString)")
                    #if os(iOS)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                taskStore.deleteTask(task)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            withAnimation {
                                taskStore.toggleCompletion(task)
                            }
                        } label: {
                            Label(
                                task.isCompleted ? "Uncomplete" : "Complete",
                                systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark"
                            )
                        }
                        .tint(task.isCompleted ? .orange : .green)
                    }
                    #endif
            }
            .onDelete { offsets in
                taskStore.deleteTasks(at: offsets)
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.inset)
        #endif
        .animation(.default, value: taskStore.filteredTasks)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Tasks", systemImage: "checkmark.circle")
        } description: {
            Text("Tap the + button to add a new task")
        }
        .accessibilityIdentifier("emptyStateView")
    }
}

// MARK: - Task Row View
struct TaskRowView: View {
    @EnvironmentObject var taskStore: TaskStore
    let task: TodoTask
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Completion checkbox - 44pt tap target per HIG
            Button {
                withAnimation(.spring(response: 0.3)) {
                    taskStore.toggleCompletion(task)
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
                    .frame(width: 44, height: 44) // HIG minimum tap target
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("taskCheckbox_\(task.id.uuidString)")
            .accessibilityLabel(task.isCompleted ? "Mark \(task.title) incomplete" : "Mark \(task.title) complete")
            
            VStack(alignment: .leading, spacing: 4) {
                // Task title - readable font size
                Text(task.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                    .lineLimit(2)
                    .accessibilityIdentifier(task.title) // Use title as identifier for test matching
                
                // Metadata row - compact but readable
                HStack(spacing: 6) {
                    // Date with icon
                    Label(task.formattedDueDate, systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(task.isOverdue && !task.isCompleted ? .red : .secondary)
                        .accessibilityIdentifier("taskDueDate")
                    
                    // Time
                    Text("·")
                        .foregroundStyle(.tertiary)
                    
                    Text(task.formattedDueTime)
                        .font(.caption)
                        .foregroundStyle(task.isOverdue && !task.isCompleted ? .red : .secondary)
                        .accessibilityIdentifier("taskDueTime")
                    
                    // Priority indicator
                    if task.priority != .none {
                        PriorityBadge(priority: task.priority)
                    }
                }
                .labelStyle(.titleAndIcon)
                
                // Notes preview - only show if has notes
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                        .accessibilityIdentifier("taskNotesPreview")
                }
            }
            
            Spacer(minLength: 8)
            
            // Chevron indicator - centered vertically
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
        .frame(minHeight: 60) // Comfortable row height
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Double tap to view details")
    }
}

// MARK: - Priority Badge
struct PriorityBadge: View {
    let priority: Priority
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: priority.iconName)
                .font(.caption2)
        }
        .foregroundStyle(priorityColor)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(priorityColor.opacity(0.15))
        .clipShape(Capsule())
    }
    
    private var priorityColor: Color {
        switch priority {
        case .none: return .gray
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}

#Preview {
    NavigationStack {
        TaskListView(selectedTask: .constant(nil))
            .environmentObject(TaskStore())
    }
}
