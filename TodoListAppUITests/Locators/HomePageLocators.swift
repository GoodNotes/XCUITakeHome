//
//  HomePageLocators.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

class HomePageLocators {
    
    static var addTaskButton = app.buttons["addTaskButton"]
    static var sideBarButton = app.buttons["Show Sidebar"]
    static var searchBar = app.searchFields["Search tasks"]
    static var groceryTask = app.buttons.matching(NSPredicate(format : "label CONTAINS[c] %@", "Buy groceries")).firstMatch
    static var dentistTask = app.buttons.matching(NSPredicate(format : "label CONTAINS[c] %@", "Call dentist")).firstMatch
    static var dogTask = app.buttons.matching(NSPredicate(format : "label CONTAINS[c] %@", "Walk the dog")).firstMatch
}
