//
//  TaskStore.swift
//  TodoListApp
//
//  ViewModel managing task data and persistence
//

import Foundation
import SwiftUI

/// Main data store for managing tasks
class TaskStore: ObservableObject {
    @Published var tasks: [TodoTask] = []
    @Published var selectedList: TaskList = .reminders
    @Published var searchText: String = ""
    
    init() {
        loadTasks()
    }
    
    // MARK: - Computed Properties
    
    /// Tasks filtered by current list selection
    var filteredTasks: [TodoTask] {
        var filtered: [TodoTask]
        
        switch selectedList {
        case .reminders:
            filtered = tasks.filter { !$0.isCompleted }
        case .today:
            filtered = tasks.filter { $0.isDueToday && !$0.isCompleted }
        case .scheduled:
            filtered = tasks.filter { !$0.isCompleted }.sorted { $0.dueDate < $1.dueDate }
        case .flagged:
            filtered = tasks.filter { $0.priority == .high && !$0.isCompleted }
        case .completed:
            filtered = tasks.filter { $0.isCompleted }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    /// Count of tasks in each list
    var taskCounts: [TaskList: Int] {
        [
            .reminders: tasks.filter { !$0.isCompleted }.count,
            .today: tasks.filter { $0.isDueToday && !$0.isCompleted }.count,
            .scheduled: tasks.filter { !$0.isCompleted }.count,
            .flagged: tasks.filter { $0.priority == .high && !$0.isCompleted }.count,
            .completed: tasks.filter { $0.isCompleted }.count
        ]
    }
    
    /// Tasks grouped by due date
    var groupedByDate: [Date: [TodoTask]] {
        Dictionary(grouping: filteredTasks) { task in
            Calendar.current.startOfDay(for: task.dueDate)
        }
    }
    
    /// Overdue tasks
    var overdueTasks: [TodoTask] {
        tasks.filter { $0.isOverdue }
    }
    
    // MARK: - CRUD Operations
    
    /// Add a new task
    func addTask(_ task: TodoTask) {
        tasks.append(task)
    }
    
    /// Update an existing task
    func updateTask(_ task: TodoTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    /// Delete a task
    func deleteTask(_ task: TodoTask) {
        tasks.removeAll { $0.id == task.id }
    }
    
    /// Delete tasks at indices
    func deleteTasks(at offsets: IndexSet) {
        let tasksToDelete = offsets.map { filteredTasks[$0] }
        for task in tasksToDelete {
            deleteTask(task)
        }
    }
    
    /// Toggle task completion
    func toggleCompletion(_ task: TodoTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            tasks[index].completedAt = tasks[index].isCompleted ? Date() : nil
        }
    }
    
    /// Clear all completed tasks
    func clearCompleted() {
        tasks.removeAll { $0.isCompleted }
    }
    
    // MARK: - Data Loading
    
    private func loadTasks() {
        // Always start fresh with demo data
        tasks = TodoTask.sampleTasks
    }
    
    // MARK: - Helpers
    
    /// Create a new task with default values
    func createNewTask() -> TodoTask {
        TodoTask(
            title: "",
            notes: "",
            dueDate: Date(),
            list: selectedList == .completed ? .reminders : selectedList
        )
    }
}

