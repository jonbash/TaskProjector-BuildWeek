//
//  RealmControllerTests.swift
//  TaskProjectorTests
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import XCTest
@testable import RealmSwift
@testable import TaskProjector

class RealmControllerTests: XCTestCase {
    var realmController: RealmController!
    var testRealm: Realm!

    override func setUp() {
        super.setUp()
        realmController = RealmController()
        testRealm = try? Realm(configuration: Realm.Configuration(
            inMemoryIdentifier: "TaskProjectorTestRealm"))
    }

    // MARK: - Tests

    func testCreateTask() {
        XCTAssertNoThrow(try createNewTask())
    }

    func testModifyTask() {
        let dueDate = Date()
        let name = "Task name"

        do {
            let task = try createNewTask()
            try realmController.save(task, inContext: testRealm)

            try realmController.performUpdates(inContext: testRealm) {
                task.name = name
                task.dueDate = dueDate
            }

            XCTAssertEqual(task.name, name)
            XCTAssertEqual(task.dueDate, dueDate)
        } catch {
            XCTFail("Error thrown: \(error)")
        }
    }

    // MARK: - Helper Methods

    private func createNewTask() throws -> Task {
        try self.realmController.create(
            Task.self,
            inContext: self.testRealm)
    }
}
