//
//  EditTaskSteps.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

extension UITestBase {
    
    func openEditTaskView() {
        HomePageLocators.groceryTask.waitAndTap(customError: "Grocery task not visible or cannot be tapped")
        TaskViewLocators.editTask.waitAndTap(customError: "Edit title not visible or cannot be tapped")
    }
    
    func editPriorityOfTaskAndAssertOnHomepage() {
        if TaskViewLocators.macHighPriorityButton.exists {
            TaskViewLocators.macHighPriorityButton.waitAndTap(customError: "High priority not visible or cannot be tapped")
        } else {
            TaskViewLocators.priorityPickerEditPage.waitAndTap(customError: "Priority value not visible or cannot be tapped")
            TaskViewLocators.highPriority.waitAndTap(customError: "High priority not visible or cannot be tapped")
        }
        
        TaskViewLocators.doneButton.waitAndTap(customError: "Done button not visible or cannot be tapped")
        TaskViewLocators.highPriorityFlag.waitForElementToExist(customError: "Edited grocery task not visible")
    }
}
