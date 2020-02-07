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

    func testSaveObjects() throws {
        let homeTag = Tag(name: "Home")
        let workTag = Tag(name: "Work")
        let personalArea = Area(name: "Personal")
        let professionalArea = Area(name: "Professional")
        let save = {
            try self.taskController.saveObjects(
                [homeTag, workTag, personalArea, professionalArea])
        }
        XCTAssertNoThrow(try save())
    }

    func testAllTasksList() throws {
        var tasks = [Task]()
        var task42: Task?
        for i in 0..<100 {
            let task = Task(name: "task \(i)")
            if i == 42 { task42 = task }
            tasks.append(task)
        }
        try taskController.saveObjects(tasks)
        XCTAssertNotNil(taskController.allTasks)
        XCTAssertEqual(taskController.allTasks!.count, 100)
        XCTAssertTrue(taskController.allTasks!.contains(task42!))
    }

    func testAllAreasList() throws {
        let personalArea = Area(name: "School Stuff")
        let professionalArea = Area(name: "Health")
        try taskController.saveObjects(
            [personalArea, professionalArea])
        XCTAssertNotNil(taskController.allAreas)
        XCTAssertEqual(taskController.allAreas!.count, 4) // including defaults
        XCTAssertTrue(taskController.allAreas!.contains(personalArea))
    }

    func testAllTagsList() throws {
        let homeTag = Tag(name: "Home")
        let workTag = Tag(name: "Work")
        let schoolTag = Tag(name: "School") // let die, don't save
        try taskController.saveObjects(
            [homeTag, workTag])
        XCTAssertNotNil(taskController.allTags)
        XCTAssertEqual(taskController.allTags!.count, 4) // including defaults
        XCTAssertTrue(taskController.allTags!.contains(workTag))
        XCTAssertFalse(taskController.allTags!.contains(schoolTag))
    }

    func testDeleteTask() throws {
        var tasks = [Task]()
        var task42: Task?
        for i in 0..<100 {
            let task = Task(name: "task \(i)")
            if i == 42 { task42 = task }
            tasks.append(task)
        }
        try taskController.saveObjects(tasks)
        XCTAssertEqual(taskController.allTasks!.count, 100)
        XCTAssertTrue(taskController.allTasks!.contains(task42!))
        XCTAssertNoThrow(try taskController.delete(task42!))
        XCTAssertEqual(taskController.allTasks!.count, 99)
        XCTAssertFalse(taskController.allTasks!.contains(task42!))
    }

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
