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
    private var realmController = RealmController()

    lazy var topLevelTasks: Results<Task> = {
        realmController.fetch(
            Task.self,
            withPredicate: "parentArea = nil AND parentProject = nil")
    }()
    lazy var topLevelAreas: Results<Area> = {
        realmController.fetch(Area.self, withPredicate: "parent = nil")
    }()
    lazy var topLevelTags: Results<Tag> = {
        realmController.fetch(Tag.self, withPredicate: "parent = nil")
    }()

    func addTask(_ task: Task) throws {
        try realmController.add(task)
    }

    func performUpdates(_ updates: @escaping () -> Void) throws {
        try realmController.performUpdates(updates)
    }
}
