//
//  UITestBase.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

let app = XCUIApplication()

class UITestBase : XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
}
