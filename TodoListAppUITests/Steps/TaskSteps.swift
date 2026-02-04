//
//  TaskSteps.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

extension UITestBase {
    
    func openAddTaskViewAndAssert() {
        if HomePageLocators.sideBarButton.exists {
            HomePageLocators.sideBarButton.waitAndTap(customError: "Side bar button not found")
        }
        HomePageLocators.addTaskButton.waitAndTap(timeout: 10, customError: "Add task button not visible")
        TaskViewLocators.newReminderHeader.waitForElementToExist(customError: "New reminder header not visible, add task button may not have been tapped")
    }
    
    func populateAddTaskTitleField() {
        TaskViewLocators.titleField.typeText("Walk the dog")
    }
    
    func populateAddTaskDueDateField() {
        if TaskViewLocators.macDueDateToggle.exists {
            TaskViewLocators.macDueDateToggle.waitAndTap(customError: "Due date toggle not visible")
        } else {
            TaskViewLocators.dueDateToggle.waitAndTap(customError: "Due date toggle not visible")
        }
        
        //Adding if statement as due date toggle has tapping flakiness on iphone and ipad
        if TaskViewLocators.dueDateToggle.exists && TaskViewLocators.dueDateToggle.value as? String == "0"  {
            TaskViewLocators.dueDateToggle.waitAndTap(customError: "Due date toggle not visible")
        }
        
        TaskViewLocators.dueDatePicker.waitForElementToExist(timeout: 10, customError: "Due date picker not visible")
    }
    
    func populateAddTaskPriorityField() {
        if TaskViewLocators.macPriorityPicker.exists {
            TaskViewLocators.macPriorityPicker.waitAndTap(customError: "Priority picker not visible")
        } else {
            TaskViewLocators.priorityPicker.waitAndTap(customError: "Priority picker not visible")
        }
        
        if TaskViewLocators.macHighPriority.exists {
            TaskViewLocators.macHighPriority.waitAndTap(customError: "High priority option not visible")
        } else {
            TaskViewLocators.highPriority.waitAndTap(customError: "High priority option not visible")
        }
    }
    
    func addTaskAndAssertOnHomePage() {
        TaskViewLocators.addReminderButton.waitAndTap(customError: "Add Reminder button not visible")
        HomePageLocators.dogTask.waitForElementToExist(customError: "Walk the task dog not displayed, may not have been created")
    }
    
    func searchForTaskAndAssertList() {
        HomePageLocators.searchBar.waitAndTap(customError: "Search bar not visible")
        HomePageLocators.searchBar.typeText("Buy Groc")
        HomePageLocators.groceryTask.waitForElementToExist(customError: "Grocery task not viisble")
        HomePageLocators.dentistTask.waitForElementToNotExist(customError: "Dentist task still visible, search may not have worked")
    }
}
