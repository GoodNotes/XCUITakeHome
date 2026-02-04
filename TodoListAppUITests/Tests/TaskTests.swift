//
//  TaskTests.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

class TaskTests : UITestBase {
    
    func testCreatingTaskPopulateDatePriorityTitleFields() {
        openAddTaskViewAndAssert()
        populateAddTaskPriorityField()
        populateAddTaskDueDateField()
        populateAddTaskTitleField()
        addTaskAndAssertOnHomePage()
    }
    
    func testEditingPriorityOfTask() {
        openEditTaskView()
        editPriorityOfTaskAndAssertOnHomepage()
    }
    
    func testSearchingForTask() {
        searchForTaskAndAssertList()
    }
}
