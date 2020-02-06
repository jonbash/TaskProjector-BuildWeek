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

    // MARK: - Fetch Results

    // ---

    // MARK: Tasks

    lazy var allTasks: Results<Task>? = { fetch(Task.self) }()
    var nextTasks: [Task] {
        guard let results = fetch(Task.self, predicate:
            NSPredicate(format: "isProject == NO AND _state != %@ AND _state != %@",
                        CompletableState.done.rawValue,
                        CompletableState.dropped.rawValue))
            else { return [] }
        var sortedTasks = results.sorted { $0.urgency > $1.urgency }
        if sortedTasks.count > 6 {
            sortedTasks.removeLast(sortedTasks.count - 6)
        }
        return sortedTasks
    }
    lazy var topLevelTasks: Results<Task>? = {
        fetch(Task.self,
              predicate: NSPredicate(format: "parentArea == nil AND parentProject == nil"))
    }()
    lazy var allProjects: Results<Task>? = {
        fetch(Task.self, predicate: NSPredicate(
            format: "isProject == YES"))
    }()

    // MARK: Areas

    lazy var allAreas: Results<Area>? = { fetch(Area.self) }()
    lazy var topLevelAreas: Results<Area>? = {
        fetch(Area.self, predicate: NSPredicate(format: "parent == nil"))
    }()

    // MARK: Tags

    lazy var allTags: Results<Tag>? = { fetch(Tag.self) }()
    lazy var topLevelTags: Results<Tag>? = {
        fetch(Tag.self, predicate: NSPredicate(format: "parent == nil"))
    }()
    lazy var tagsWithLocations: Results<Tag>? = {
        fetch(Tag.self,
              predicate: NSPredicate(format:"latitude != nil AND longitude != nil"))
    }()
    var tagLocationAnnotations: [Tag.MapAnnotation] {
        tagsWithLocations?.compactMap { $0.mapAnnotation } ?? []
    }

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

    func fetch<T: Object>(_ object: T.Type,
                          predicate: NSPredicate? = nil,
                          sorting: Sorting? = nil
    ) -> Results<T>? {
        do {
            return try realmController.fetch(T.self,
                                             predicate: predicate,
                                             sorting: sorting)
        } catch {
            NSLog("Error fetching \(T.self) results: \(error)")
            return nil
        }
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
