//
//  XCUIElementHelpers.swift
//  TodoListAppUITests
//
//  Created by Ellie Clifford on 04/02/2026.
//

import XCTest

extension XCUIElement {
    
    func waitForElementToExist(timeout : TimeInterval = 5.0, customError: String) {
        if !self.waitForExistence(timeout: timeout) {
            XCTFail(customError)
        }
    }
    
    func waitAndTap(timeout : TimeInterval = 5.0, customError: String) {
        if !self.waitForExistence(timeout: timeout) {
            XCTFail(customError)
            return
        }
        if !self.isHittable {
            XCTFail(customError)
            return
        }
        self.tap()
    }
    
    func waitForElementToNotExist(timeout : TimeInterval = 5.0, customError: String) {
        if self.waitForExistence(timeout: timeout) {
            XCTFail(customError)
        }
    }
}
