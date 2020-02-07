//
//  TaskController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class TaskController {
    private var realmController: RealmController

    // MARK: - Fetch Results

    // ---

    // MARK: Tasks

    lazy var allTasks: Results<Task>? = { fetch(Task.self) }()
    lazy var availableTasks: Results<Task>? = {
        fetch(Task.self, predicate:
            NSPredicate(format: "isProject == NO AND _state != %@ AND _state != %@",
                        CompletableState.done.rawValue,
                        CompletableState.dropped.rawValue))
    }()
    var nextTasks: [Task] {
        guard let results = availableTasks else { return [] }
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
              predicate: NSPredicate(format: "latitude != nil AND longitude != nil"))
    }()
    var tagLocationAnnotations: [TagMapAnnotation] {
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
                try saveObjects([homeTag, workTag])
            } catch {
                NSLog("Error initalizing default tags: \(error)")
            }
        }
        if let noAreas = topLevelAreas?.isEmpty, noAreas {
            NSLog("Initializing default areas")
            do {
                let personalArea = Area(name: "Personal")
                let professionalArea = Area(name: "Professional")
                try saveObjects([personalArea, professionalArea])
            } catch {
                NSLog("Error initalizing default areas: \(error)")
            }
        }
    }

    // MARK: - General Public Methods

    func performUpdates(_ updates: @escaping () throws -> Void) throws {
        try realmController.performUpdates(updates)
    }

    func save(_ object: Object) throws {
        try realmController.save(object)
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

    func delete(_ object: Object) throws {
        try realmController.delete(object)
    }

    // MARK: - Task Methods

    func fetchTasksNearby(_ region: CLCircularRegion) -> [Task] {
        guard let tags = tagsWithLocations else { return [] }
        var nearbyTasks = [Task]()
        for tag in tags {
            guard let location = tag.location else { continue }
            if region.contains(location) {
                for task in tag.tasks {
                    if !nearbyTasks.contains(task) {
                        nearbyTasks.append(task)
                    }
                }
            }
        }
        return nearbyTasks
    }
}
