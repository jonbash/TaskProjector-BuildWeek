//
//  TaskProjectorUITests.swift
//  TaskProjectorUITests
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import XCTest

class TaskProjectorUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - UI Elements

    var returnButton: XCUIElement { app.buttons["Return"] }

    // next tasks
    var toolbar: XCUIElement { app.toolbars["Toolbar"] }
    var nextNavBar: XCUIElement { app.navigationBars["Next Tasks"] }
    var addToolbarButton: XCUIElement { toolbar.buttons["Add"] }
    var nearbyButton: XCUIElement { toolbar.buttons["Nearby"] }
    var tagsButton: XCUIElement { toolbar.buttons["Tags"] }

    // New task
    var saveButton: XCUIElement { toolbar.buttons["Save"] }
    var nextButton: XCUIElement { toolbar.buttons["Next >"] }
    var taskTitleField: XCUIElement { app.textFields["Task title"] }

    // MARK: - Setup/TearDown

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false

        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests

    func testStartScreen() {
        XCTAssert(toolbar.exists)
        XCTAssert(nextNavBar.exists)
        XCTAssert(addToolbarButton.exists)
        XCTAssert(nearbyButton.exists)
        XCTAssert(tagsButton.exists)
        XCTAssert(addToolbarButton.isEnabled)
        XCTAssert(nearbyButton.isEnabled)
        XCTAssert(tagsButton.isEnabled)
    }

    func testEmptyTask() {
        addToolbarButton.tap()

        XCTAssert(saveButton.exists)
        XCTAssert(nextButton.exists)
        XCTAssertFalse(saveButton.isEnabled)
        XCTAssertFalse(nextButton.isEnabled)

        taskTitleField.tap()
        taskTitleField.typeText("Test task")
        returnButton.tap()

        XCTAssert(saveButton.isHittable)
        XCTAssert(nextButton.isHittable)

        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()

        XCTAssertFalse(nextButton.isEnabled)
        XCTAssert(saveButton.isEnabled)
    }
}
