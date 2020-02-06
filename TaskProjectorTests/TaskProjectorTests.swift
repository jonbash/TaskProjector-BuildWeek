//
//  TaskProjectorTests.swift
//  TaskProjectorTests
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import XCTest
@testable import TaskProjector
@testable import RealmSwift

class TaskProjectorTests: XCTestCase {
    var testRealm: Realm!
    var realmController: RealmController!
    var taskController: TaskController!

    override func setUp() {
        super.setUp()
        testRealm = try? Realm(configuration: Realm.Configuration(
            inMemoryIdentifier: "TaskProjectorTestRealm \(UUID().uuidString)"))
        realmController = RealmController(testRealm)
        taskController = TaskController(realmController)
    }

    // MARK: - Realm Controller Tests

    func testCreateTask() {
        XCTAssertNoThrow(try createAndSaveTask())
    }

    func testModifyTask() throws {
        let dueDate = Date()
        let name = "Task name"

        let task = try createAndSaveTask()

        try realmController.performUpdates(inContext: testRealm) {
            task.name = name
            task.dueDate = dueDate
        }

        XCTAssertEqual(task.name, name)
        XCTAssertEqual(task.dueDate, dueDate)
    }

    func testFetchTasks() throws {
        for i in 0..<100 {
            try createAndSaveTask(withName: "task \(i)")
        }
        let tasks = try realmController.fetch(Task.self, fromContext: testRealm)
        XCTAssertEqual(tasks.count, 100)
    }

    // MARK: - Task Controller Tests

    // MARK: - Misc Tests

    func testRescaler() {
        let rescaler = Rescaler(from: (lowerBound: 0, upperBound: 10),
                                to: (lowerBound: 100, upperBound: 200))
        XCTAssertEqual(rescaler.rescale(5), 150)
        XCTAssertEqual(rescaler.rescale(0.25), 102.5)
    }

    func testRescalerReverse() {
        let reverseRescaler = Rescaler(from: (lowerBound: 0, upperBound: 1),
                                       to: (lowerBound: 100, upperBound: 0))
        XCTAssertEqual(reverseRescaler.rescale(0.1), 90)
        XCTAssertEqual(reverseRescaler.rescale(1), 0)
    }

    // MARK: - Helper methods

    @discardableResult
    func createAndSaveTask(withName name: String = "Test") throws -> Task {
        let task = Task(name: name)
        try realmController.save(task, inContext: testRealm)
        return task
    }
}
