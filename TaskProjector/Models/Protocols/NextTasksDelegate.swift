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

    func didRequestTaskCreation(_ sender: Any?)
    func performUpdates(forTask task: Task, updates: @escaping () throws -> Void)
}
