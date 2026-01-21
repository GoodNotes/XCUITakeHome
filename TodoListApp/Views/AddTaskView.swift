//
//  AddTaskView.swift
//  TodoListApp
//
//  View for creating new tasks - Apple HIG compliant
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskStore: TaskStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var hasDueTime: Bool = false
    @State private var priority: Priority = .none
    
    @FocusState private var isTitleFocused: Bool
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            #if os(macOS)
            macOSLayout
            #else
            iOSLayout
            #endif
        }
        .onAppear {
            // Auto-focus title field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }
    
    // MARK: - iOS Layout
    #if os(iOS)
    private var iOSLayout: some View {
        List {
            // MARK: Title Section - Primary input with 44pt minimum height
            Section {
                TextField("What do you want to remember?", text: $title, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...3)
                    .focused($isTitleFocused)
                    .accessibilityIdentifier("taskTitleField")
                    .submitLabel(.done)
                    .frame(minHeight: 44) // HIG minimum tap target
            }
            
            // MARK: Notes Section - Progressive disclosure (shows after title)
            if !title.isEmpty {
                Section {
                    TextField("Add notes (optional)", text: $notes, axis: .vertical)
                        .font(.body)
                        .lineLimit(1...5)
                        .accessibilityIdentifier("taskNotesField")
                        .frame(minHeight: 44)
                } header: {
                    Text("Notes")
                }
            }
            
            // MARK: Schedule Section - Date and time with proper tap targets
            Section {
                // Due Date Toggle - 44pt height for toggle row
                Toggle(isOn: $hasDueDate.animation()) {
                    Label("Date", systemImage: "calendar")
                        .foregroundStyle(hasDueDate ? .red : .primary)
                }
                .tint(.red)
                .frame(minHeight: 44)
                .accessibilityIdentifier("dueDateToggle")
                
                if hasDueDate {
                    // Compact date picker that shows inline
                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .environment(\.locale, Locale(identifier: "en_GB"))
                    .accessibilityIdentifier("dueDatePicker")
                    .frame(minHeight: 44)
                    
                    // Time Toggle
                    Toggle(isOn: $hasDueTime.animation()) {
                        Label("Time", systemImage: "clock")
                            .foregroundStyle(hasDueTime ? .blue : .primary)
                    }
                    .tint(.blue)
                    .frame(minHeight: 44)
                    .accessibilityIdentifier("dueTimeToggle")
                    
                    if hasDueTime {
                        DatePicker(
                            "Due Time",
                            selection: $dueDate,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                        .environment(\.locale, Locale(identifier: "en_GB"))
                        .accessibilityIdentifier("dueTimePicker")
                        .frame(minHeight: 44)
                    }
                }
            } header: {
                Text("Schedule")
            } footer: {
                if hasDueDate {
                    Text(formattedDateTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("formattedDateTimePreview")
                }
            }
            
            // MARK: Priority Section - Separate for clarity
            Section {
                HStack {
                    Label("Priority", systemImage: priority == .none ? "flag" : "flag.fill")
                        .foregroundStyle(priorityColor)
                    
                    Spacer()
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { p in
                            Text(p.displayName).tag(p)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .accessibilityIdentifier("priorityPicker")
                }
                .frame(minHeight: 44) // HIG minimum tap target
            } header: {
                Text("Priority")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("New Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .accessibilityIdentifier("cancelButton")
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    addTask()
                }
                .fontWeight(.semibold)
                .disabled(!canSave)
                .accessibilityIdentifier("saveTaskButton")
            }
        }
    }
    #endif
    
    // MARK: - macOS Layout
    #if os(macOS)
    private var macOSLayout: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                .accessibilityIdentifier("cancelButton")
                
                Spacer()
                
                Text("New Reminder")
                    .font(.headline)
                
                Spacer()
                
                Button("Add") {
                    addTask()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)
                .accessibilityIdentifier("saveTaskButton")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.bar)
            
            Divider()
            
            // Content - compact layout
            VStack(alignment: .leading, spacing: 16) {
                // Title
                TextField("What do you want to remember?", text: $title, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .focused($isTitleFocused)
                    .lineLimit(1...2)
                    .accessibilityIdentifier("taskTitleField")
                
                // Notes - compact single line with expand option
                TextField("Notes (optional)", text: $notes, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(1...3)
                    .accessibilityIdentifier("taskNotesField")
                
                Divider()
                
                // Schedule row
                HStack {
                    Toggle(isOn: $hasDueDate.animation()) {
                        Label("Date", systemImage: "calendar")
                    }
                    .toggleStyle(.checkbox)
                    
                    if hasDueDate {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "en_GB"))
                            .accessibilityIdentifier("dueDatePicker")
                    }
                    
                    Spacer()
                }
                
                if hasDueDate {
                    HStack {
                        Toggle(isOn: $hasDueTime.animation()) {
                            Label("Time", systemImage: "clock")
                        }
                        .toggleStyle(.checkbox)
                        
                        if hasDueTime {
                            DatePicker("", selection: $dueDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .environment(\.locale, Locale(identifier: "en_GB"))
                                .accessibilityIdentifier("dueTimePicker")
                        }
                        
                        Spacer()
                    }
                }
                
                Divider()
                
                // Priority row - inline picker
                HStack {
                    Label("Priority", systemImage: priority == .none ? "flag" : "flag.fill")
                        .foregroundStyle(priorityColor)
                    
                    Spacer()
                    
                    Picker("", selection: $priority) {
                        ForEach(Priority.allCases) { p in
                            Text(p.displayName).tag(p)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 100)
                    .accessibilityIdentifier("priorityPicker")
                }
                
                // Date preview
                if hasDueDate {
                    Text(formattedDateTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("formattedDateTimePreview")
                }
                
                Spacer()
            }
            .padding(20)
        }
        .frame(width: 360, height: hasDueDate ? (hasDueTime ? 320 : 280) : 240)
    }
    #endif
    
    // MARK: - Helpers
    
    private var priorityColor: Color {
        colorForPriority(priority)
    }
    
    private func colorForPriority(_ p: Priority) -> Color {
        switch p {
        case .none: return .primary
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private var formattedDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        if hasDueTime {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.locale = Locale(identifier: "en_GB")
            return "\(dateFormatter.string(from: dueDate)) at \(timeFormatter.string(from: dueDate))"
        } else {
            return dateFormatter.string(from: dueDate)
        }
    }
    
    private func addTask() {
        // If no due date selected, use a far future date
        let taskDueDate = hasDueDate ? dueDate : Calendar.current.date(byAdding: .year, value: 100, to: Date())!
        
        let newTask = TodoTask(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: taskDueDate,
            priority: priority
        )
        
        taskStore.addTask(newTask)
        dismiss()
    }
}

#Preview {
    AddTaskView()
        .environmentObject(TaskStore())
}
