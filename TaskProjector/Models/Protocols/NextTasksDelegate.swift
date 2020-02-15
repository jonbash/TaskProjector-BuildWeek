//
//  NextTasksDelegate.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol NextTasksDelegate: AnyObject, AddEditTaskOrigin {
    var nextTasks: [Task] { get }

    func viewTags()
    func viewNearbyTasks()
    func performUpdates(forTask task: Task, updates: @escaping () throws -> Void)
}
