//
//  TaskController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

class TaskController {
    private var realmController: RealmController

    // MARK: - Top Level Models

    lazy var allTasks: Results<Task>? = {
        do {
            return try realmController.fetch(
                Task.self,
                predicate: nil,
                sorting: nil)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }()
    // TODO: make algorithm for next tasks
    var nextTasks: Results<Task>? { allTasks }

    lazy var topLevelTasks: Results<Task>? = {
        do {
            return try realmController.fetch(
                Task.self,
                predicate: NSPredicate(format: "parentArea = nil AND parentProject = nil"),
                sorting: nil)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }()
    lazy var topLevelAreas: Results<Area>? = {
        do {
            return try realmController.fetch(
                Area.self,
                predicate: NSPredicate(format: "parent = nil"),
                sorting: nil)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }()
    lazy var topLevelTags: Results<Tag>? = {
        do {
            return try realmController.fetch(
                Tag.self,
                predicate: NSPredicate(format: "parent = nil"),
                sorting: nil)
        } catch {
            NSLog("Error fetching tags: \(error)")
            return nil
        }
    }()

    // MARK: - Init

    init(_ localStore: RealmController = RealmController()) {
        self.realmController = localStore
        if let noTags = topLevelTags?.isEmpty, noTags {
            NSLog("Initializing default tags")
            do {
                let homeTag = Tag(name: "Home")
                let workTag = Tag(name: "Work")
                try saveTag(homeTag)
                try saveTag(workTag)
            } catch {

            }
        }
    }

    // MARK: - General Public Methods

    func performUpdates(_ updates: @escaping () throws -> Void) throws {
        try realmController.performUpdates(updates)
    }

    func saveObjects(_ objects: [Object]) throws {
        try realmController.saveObjects(objects)
    }

    // MARK: - Task Methods

    func saveTask(_ task: Task) throws {
        try realmController.save(task)
    }

    // MARK: - Tag Methods

    func saveTag(_ tag: Tag) throws {
        try realmController.save(tag)
    }
}
