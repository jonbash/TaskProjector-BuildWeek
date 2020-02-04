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
    private var localStore: PersistenceController

    // MARK: - Top Level Models

    lazy var allTasks: Results<Task>? = {
        do {
            return try localStore.fetch(
                Task.self,
                expectingCollectionType: Results<Task>.self,
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
            return try localStore.fetch(
                Task.self,
                expectingCollectionType: Results<Task>.self,
                predicate: NSPredicate(format: "parentArea = nil AND parentProject = nil"),
                sorting: nil)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }()
    lazy var topLevelAreas: Results<Area>? = {
        do {
            return try localStore.fetch(
                Area.self,
                expectingCollectionType: Results<Area>.self,
                predicate: NSPredicate(format: "parent = nil"),
                sorting: nil)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }()
    lazy var topLevelTags: Results<Tag>? = {
        do {
            return try localStore.fetch(
                Tag.self,
                expectingCollectionType: Results<Tag>.self,
                predicate: NSPredicate(format: "parent = nil"),
                sorting: nil)
        } catch {
            NSLog("Error fetching tags: \(error)")
            return nil
        }
    }()

    // MARK: - Init

    init(_ localStore: PersistenceController = RealmController()) {
        self.localStore = localStore
        if let noTags = topLevelTags?.isEmpty, noTags {
            NSLog("Initializing default tags")
            do {
                let homeTag = try newTag()
                let workTag = try newTag()
                try performUpdates {
                    homeTag.name = "Home"
                    workTag.name = "Work"
                }
                try saveTag(homeTag)
                try saveTag(workTag)
            } catch {

            }
        }
    }

    // MARK: - General Public Methods

    func performUpdates(_ updates: @escaping () -> Void) throws {
        try localStore.performUpdates(updates)
    }

    // MARK: - Task Methods

    func newTask() throws -> Task {
        try localStore.create(Task.self)
    }

    func saveTask(_ task: Task) throws {
        try localStore.save(task)
    }

    // MARK: - Tag Methods

    func newTag() throws -> Tag {
        try localStore.create(Tag.self)
    }

    func saveTag(_ tag: Tag) throws {
        try localStore.save(tag)
    }
}
