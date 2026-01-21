//
//  TaskDetailView.swift
//  TodoListApp
//
//  Detailed view and edit screen for a task - Apple HIG compliant
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var taskStore: TaskStore
    @Environment(\.dismiss) private var dismiss
    
    let task: TodoTask
    
    @State private var editedTitle: String = ""
    @State private var editedNotes: String = ""
    @State private var editedDueDate: Date = Date()
    @State private var editedPriority: Priority = .none
    @State private var isEditing: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @FocusState private var isTitleFocused: Bool
    
    // Computed property to get the current task state from the store
    private var currentTask: TodoTask {
        taskStore.tasks.first(where: { $0.id == task.id }) ?? task
    }
    
    var body: some View {
        #if os(macOS)
        macOSLayout
        #else
        iOSLayout
        #endif
    }
    
    // MARK: - iOS Layout
    #if os(iOS)
    private var iOSLayout: some View {
        List {
            // MARK: Hero Section - Title & Quick Actions
            Section {
                // Main task info with completion toggle
                HStack(alignment: .center, spacing: 14) {
                    // Completion Button - 44pt tap target per HIG
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            taskStore.toggleCompletion(currentTask)
                        }
                    } label: {
                        Image(systemName: currentTask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 26))
                            .foregroundStyle(currentTask.isCompleted ? .green : .secondary)
                            .contentTransition(.symbolEffect(.replace))
                            .frame(width: 44, height: 44) // HIG minimum tap target
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("toggleCompletionButton")
                    .accessibilityLabel(currentTask.isCompleted ? "Mark incomplete" : "Mark complete")
                    
                    VStack(alignment: .leading, spacing: 6) {
                        if isEditing {
                            TextField("Title", text: $editedTitle, axis: .vertical)
                                .font(.body.weight(.semibold))
                                .focused($isTitleFocused)
                                .accessibilityIdentifier("editTaskTitleField")
                        } else {
                            Text(currentTask.title)
                                .font(.body.weight(.semibold))
                                .strikethrough(currentTask.isCompleted)
                                .foregroundStyle(currentTask.isCompleted ? .secondary : .primary)
                                .accessibilityIdentifier("taskDetailTitle")
                        }
                        
                        // Status indicators inline
                        HStack(spacing: 8) {
                            statusBadge
                            if currentTask.priority != .none {
                                priorityBadge
                            }
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            }
            
            // MARK: Details Section - Notes & Schedule combined
            Section {
                // Notes row
                VStack(alignment: .leading, spacing: 4) {
                    Label("Notes", systemImage: "note.text")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    
                    if isEditing {
                        TextField("Add notes", text: $editedNotes, axis: .vertical)
                            .lineLimit(2...8)
                            .font(.body)
                            .accessibilityIdentifier("editTaskNotesField")
                    } else {
                        Text(currentTask.notes.isEmpty ? "No notes" : currentTask.notes)
                            .font(.body)
                            .foregroundStyle(currentTask.notes.isEmpty ? .tertiary : .primary)
                            .italic(currentTask.notes.isEmpty)
                            .accessibilityIdentifier("taskDetailNotes")
                    }
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                
                // Date row - 44pt height for tap target
                if isEditing {
                    DatePicker(
                        "Date",
                        selection: $editedDueDate,
                        displayedComponents: .date
                    )
                    .environment(\.locale, Locale(identifier: "en_GB"))
                    .accessibilityIdentifier("editDueDatePicker")
                } else {
                    HStack {
                        Label("Date", systemImage: "calendar")
                        Spacer()
                        Text(currentTask.formattedDueDate)
                            .foregroundStyle(currentTask.isOverdue && !currentTask.isCompleted ? .red : .secondary)
                            .accessibilityIdentifier("taskDetailDueDate")
                    }
                    .frame(minHeight: 44) // HIG tap target
                }
                
                // Time row - 44pt height for tap target
                if isEditing {
                    DatePicker(
                        "Time",
                        selection: $editedDueDate,
                        displayedComponents: .hourAndMinute
                    )
                    .environment(\.locale, Locale(identifier: "en_GB"))
                    .accessibilityIdentifier("editDueTimePicker")
                } else {
                    HStack {
                        Label("Time", systemImage: "clock")
                        Spacer()
                        Text(currentTask.formattedDueTime)
                            .foregroundStyle(currentTask.isOverdue && !currentTask.isCompleted ? .red : .secondary)
                            .accessibilityIdentifier("taskDetailDueTime")
                    }
                    .frame(minHeight: 44) // HIG tap target
                }
                
                // Overdue warning
                if currentTask.isOverdue && !currentTask.isCompleted && !isEditing {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        Text("This reminder is overdue")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.red, in: RoundedRectangle(cornerRadius: 8))
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                }
                
                // Priority (edit mode)
                if isEditing {
                    HStack {
                        Label("Priority", systemImage: "flag")
                        Spacer()
                        Picker("Priority", selection: $editedPriority) {
                            ForEach(Priority.allCases) { p in
                                Text(p.displayName).tag(p)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .accessibilityIdentifier("editPriorityPicker")
                    }
                    .frame(minHeight: 44)
                }
            } header: {
                Text("Details")
            }
            
            // MARK: Info Section - Collapsed for less clutter
            Section {
                // Created date
                HStack {
                    Text("Created")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(formatDate(currentTask.createdAt))
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
                .frame(minHeight: 44)
                
                // Completed date (if completed)
                if currentTask.isCompleted, let completedAt = currentTask.completedAt {
                    HStack {
                        Text("Completed")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(formatDate(completedAt))
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                    .frame(minHeight: 44)
                }
            }
            
            // MARK: Delete Action - Clear destructive styling
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Label("Delete Reminder", systemImage: "trash")
                            .font(.body.weight(.medium))
                        Spacer()
                    }
                    .frame(minHeight: 44) // HIG tap target
                }
                .accessibilityIdentifier("deleteTaskButton")
                .accessibilityHint("Double tap to delete this reminder")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(isEditing ? "Edit" : "Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        saveChanges()
                    } else {
                        startEditing()
                    }
                }
                .fontWeight(isEditing ? .semibold : .regular)
                .accessibilityIdentifier(isEditing ? "saveEditButton" : "editButton")
            }
            
            if isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        cancelEditing()
                    }
                    .accessibilityIdentifier("cancelEditButton")
                }
            }
        }
        .alert("Delete Reminder", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                taskStore.deleteTask(currentTask)
                dismiss()
            }
        } message: {
            Text("\"\(currentTask.title)\" will be permanently deleted.")
        }
        .onAppear {
            setupEditState()
        }
        .accessibilityIdentifier("taskDetailView")
    }
    #endif
    
    // MARK: - macOS Layout
    #if os(macOS)
    private var macOSLayout: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero Card
                GroupBox {
                    HStack(alignment: .top, spacing: 16) {
                        // Completion Button
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                taskStore.toggleCompletion(currentTask)
                            }
                        } label: {
                            Image(systemName: currentTask.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 32))
                                .foregroundStyle(currentTask.isCompleted ? .green : .secondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("toggleCompletionButton")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            if isEditing {
                                TextField("Title", text: $editedTitle)
                                    .font(.title2.weight(.semibold))
                                    .textFieldStyle(.plain)
                                    .focused($isTitleFocused)
                                    .accessibilityIdentifier("editTaskTitleField")
                            } else {
                                Text(currentTask.title)
                                    .font(.title2.weight(.semibold))
                                    .strikethrough(currentTask.isCompleted)
                                    .foregroundStyle(currentTask.isCompleted ? .secondary : .primary)
                                    .accessibilityIdentifier("taskDetailTitle")
                            }
                            
                            HStack(spacing: 12) {
                                statusBadge
                                if currentTask.priority != .none {
                                    priorityBadge
                                }
                                if currentTask.isOverdue && !currentTask.isCompleted {
                                    Label("Overdue", systemImage: "exclamationmark.triangle.fill")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                }
                
                // Notes
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes", systemImage: "note.text")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        if isEditing {
                            TextEditor(text: $editedNotes)
                                .font(.body)
                                .frame(minHeight: 80)
                                .accessibilityIdentifier("editTaskNotesField")
                        } else {
                            Text(currentTask.notes.isEmpty ? "No notes" : currentTask.notes)
                                .foregroundStyle(currentTask.notes.isEmpty ? .tertiary : .primary)
                                .italic(currentTask.notes.isEmpty)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityIdentifier("taskDetailNotes")
                        }
                    }
                    .padding(4)
                }
                
                // Schedule & Priority
                HStack(alignment: .top, spacing: 16) {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Schedule", systemImage: "calendar.badge.clock")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            if isEditing {
                                DatePicker("Date", selection: $editedDueDate, displayedComponents: .date)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .accessibilityIdentifier("editDueDatePicker")
                                
                                DatePicker("Time", selection: $editedDueDate, displayedComponents: .hourAndMinute)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                                    .accessibilityIdentifier("editDueTimePicker")
                            } else {
                                LabeledContent("Date") {
                                    Text(currentTask.formattedDueDate)
                                        .foregroundStyle(currentTask.isOverdue && !currentTask.isCompleted ? .red : .secondary)
                                }
                                .accessibilityIdentifier("taskDetailDueDate")
                                
                                LabeledContent("Time") {
                                    Text(currentTask.formattedDueTime)
                                        .foregroundStyle(currentTask.isOverdue && !currentTask.isCompleted ? .red : .secondary)
                                }
                                .accessibilityIdentifier("taskDetailDueTime")
                            }
                        }
                        .padding(4)
                    }
                    
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Priority", systemImage: "flag")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            if isEditing {
                                Picker("Priority", selection: $editedPriority) {
                                    ForEach(Priority.allCases) { p in
                                        HStack {
                                            Image(systemName: p == .none ? "flag" : "flag.fill")
                                                .foregroundStyle(colorForPriority(p))
                                            Text(p.displayName)
                                        }
                                        .tag(p)
                                    }
                                }
                                .pickerStyle(.radioGroup)
                                .accessibilityIdentifier("editPriorityPicker")
                            } else {
                                HStack {
                                    Image(systemName: currentTask.priority == .none ? "flag" : "flag.fill")
                                        .foregroundStyle(colorForPriority(currentTask.priority))
                                    Text(currentTask.priority.displayName)
                                }
                                .accessibilityIdentifier("taskDetailPriority")
                            }
                        }
                        .padding(4)
                    }
                }
                
                // Info
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Info", systemImage: "info.circle")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        LabeledContent("Created") {
                            Text(formatDate(currentTask.createdAt))
                                .foregroundStyle(.secondary)
                        }
                        
                        if currentTask.isCompleted, let completedAt = currentTask.completedAt {
                            LabeledContent("Completed") {
                                Text(formatDate(completedAt))
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    .padding(4)
                }
                
                Spacer()
                
                // Actions
                HStack {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .accessibilityIdentifier("deleteTaskButton")
                    
                    Spacer()
                    
                    if isEditing {
                        Button("Cancel") {
                            cancelEditing()
                        }
                        .keyboardShortcut(.cancelAction)
                        .accessibilityIdentifier("cancelEditButton")
                        
                        Button("Save") {
                            saveChanges()
                        }
                        .keyboardShortcut(.defaultAction)
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("saveEditButton")
                    } else {
                        Button("Edit") {
                            startEditing()
                        }
                        .keyboardShortcut("e", modifiers: .command)
                        .accessibilityIdentifier("editButton")
                    }
                }
            }
            .padding(20)
        }
        .frame(minWidth: 350, idealWidth: 400)
        .background(Color(nsColor: .windowBackgroundColor))
        .alert("Delete Reminder", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                taskStore.deleteTask(currentTask)
                dismiss()
            }
        } message: {
            Text("\"\(currentTask.title)\" will be permanently deleted.")
        }
        .onAppear {
            setupEditState()
        }
        .accessibilityIdentifier("taskDetailView")
    }
    #endif
    
    // MARK: - Shared Components
    
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(currentTask.isCompleted ? .green : .orange)
                .frame(width: 8, height: 8)
            Text(currentTask.isCompleted ? "Completed" : "Pending")
                .font(.caption.weight(.medium))
                .foregroundStyle(currentTask.isCompleted ? .green : .orange)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background((currentTask.isCompleted ? Color.green : Color.orange).opacity(0.15))
        .clipShape(Capsule())
        .accessibilityIdentifier("taskStatus")
    }
    
    private var priorityBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "flag.fill")
                .font(.caption2)
            Text(currentTask.priority.displayName)
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(colorForPriority(currentTask.priority))
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(colorForPriority(currentTask.priority).opacity(0.15))
        .clipShape(Capsule())
        .accessibilityIdentifier("taskDetailPriority")
    }
    
    // MARK: - Helpers
    
    private func colorForPriority(_ p: Priority) -> Color {
        switch p {
        case .none: return .secondary
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: date)
    }
    
    private func setupEditState() {
        editedTitle = currentTask.title
        editedNotes = currentTask.notes
        editedDueDate = currentTask.dueDate
        editedPriority = currentTask.priority
    }
    
    private func startEditing() {
        setupEditState()
        withAnimation {
            isEditing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isTitleFocused = true
        }
    }
    
    private func cancelEditing() {
        withAnimation {
            isEditing = false
        }
        setupEditState()
    }
    
    private func saveChanges() {
        var updatedTask = currentTask
        updatedTask.title = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTask.notes = editedNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTask.dueDate = editedDueDate
        updatedTask.priority = editedPriority
        
        taskStore.updateTask(updatedTask)
        withAnimation {
            isEditing = false
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: TodoTask.sampleTasks[0])
            .environmentObject(TaskStore())
    }
}
