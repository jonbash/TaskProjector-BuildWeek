//
//  TaskViewDelegate.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

protocol TaskViewDelegate: AnyObject {
    func taskView(_ taskView: TaskView, didRequestStateSelectorForTask task: Task)
    func taskView(_ taskView: TaskView,
                  willPerformUpdatesforTask task: Task,
                  updates: @escaping () throws -> Void)
}
