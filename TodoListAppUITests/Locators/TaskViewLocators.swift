//
//  TaskViewLocators.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

class TaskViewLocators {
    
    static var newReminderHeader = app.staticTexts["New Reminder"]
    static var addReminderButton = app.buttons["saveTaskButton"]
    static var titleField = app.textFields["taskTitleField"]
    static var dueDateToggle = app.switches["dueDateToggle"].switches.firstMatch
    static var priorityPicker = app.buttons["priorityPicker"]
    static var macPriorityPicker = app.popUpButtons["priorityPicker"]
    static var dueDatePicker = app.datePickers["dueDatePicker"]
    static var macDueDateToggle = app.checkBoxes["Date"]
    static var highPriority = app.buttons["High"]
    static var macHighPriority = app.menuItems["High"]
    static var editTask = app.buttons["editButton"]
    static var doneButton = app.buttons ["saveEditButton"]
    static var priorityPickerEditPage = app.buttons["editPriorityPicker"]
    static var macHighPriorityButton = app.radioButtons["High"]
    static var highPriorityFlag = app.staticTexts["High"]
}
