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
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }()

    init(_ localStore: PersistenceController = RealmController()) {
        self.localStore = localStore
    }

//    func newTask() -> Task {
//
//    }

    func performUpdates(_ updates: @escaping () -> Void) throws {

    }
}
