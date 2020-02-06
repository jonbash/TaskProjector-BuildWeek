//
//  NextTasksDelegate.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol NextTasksDelegate: AnyObject {
    var nextTasks: [Task] { get }

    func requestTaskCreation(_ sender: Any?)
    func editTask(_ task: Task)
    func viewTags()
    func performUpdates(forTask task: Task, updates: @escaping () throws -> Void)
}
