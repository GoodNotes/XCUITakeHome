//
//  Task.swift
//  TodoListApp
//
//  Model representing a to-do task
//

import Foundation

/// A to-do task with title, due date, notes, and completion status
struct TodoTask: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var title: String
    var notes: String
    var dueDate: Date
    var isCompleted: Bool
    var priority: Priority
    var createdAt: Date
    var completedAt: Date?
    var list: TaskList
    
    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        dueDate: Date = Date(),
        isCompleted: Bool = false,
        priority: Priority = .none,
        createdAt: Date = Date(),
        completedAt: Date? = nil,
        list: TaskList = .reminders
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.list = list
    }
    
    /// Formatted due date in UK format (DD/MM/YY)
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: dueDate)
    }
    
    /// Formatted due time in 24-hour format
    var formattedDueTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: dueDate)
    }
    
    /// Full formatted date and time
    var formattedDateTime: String {
        "\(formattedDueDate) at \(formattedDueTime)"
    }
    
    /// Check if task is overdue
    var isOverdue: Bool {
        !isCompleted && dueDate < Date()
    }
    
    /// Check if task is due today
    var isDueToday: Bool {
        Calendar.current.isDateInToday(dueDate)
    }
    
    /// Check if task is due tomorrow
    var isDueTomorrow: Bool {
        Calendar.current.isDateInTomorrow(dueDate)
    }
}

// MARK: - Priority Enum
enum Priority: Int, Codable, CaseIterable, Identifiable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var iconName: String {
        switch self {
        case .none: return ""
        case .low: return "exclamationmark"
        case .medium: return "exclamationmark.2"
        case .high: return "exclamationmark.3"
        }
    }
    
    var color: String {
        switch self {
        case .none: return "gray"
        case .low: return "blue"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}

// MARK: - Task List Enum
enum TaskList: String, Codable, CaseIterable, Identifiable {
    case reminders = "Reminders"
    case today = "Today"
    case scheduled = "Scheduled"
    case flagged = "Flagged"
    case completed = "Completed"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .reminders: return "list.bullet"
        case .today: return "calendar"
        case .scheduled: return "calendar.badge.clock"
        case .flagged: return "flag.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .reminders: return "blue"
        case .today: return "blue"
        case .scheduled: return "red"
        case .flagged: return "orange"
        case .completed: return "gray"
        }
    }
}

// MARK: - Sample Data
extension TodoTask {
    static let sampleTasks: [TodoTask] = [
        TodoTask(
            title: "Buy groceries",
            notes: "Milk, bread, eggs, cheese",
            dueDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
            priority: .medium
        ),
        TodoTask(
            title: "Team meeting",
            notes: "Discuss Q4 roadmap and deliverables",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            priority: .high
        ),
        TodoTask(
            title: "Call dentist",
            notes: "Book appointment for checkup",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            priority: .low
        ),
        TodoTask(
            title: "Finish project report",
            notes: "Complete sections 3-5 and add charts",
            dueDate: Date(),
            isCompleted: true,
            completedAt: Date()
        )
    ]
}

