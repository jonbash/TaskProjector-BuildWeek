//
//  TaskViewDelegate.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol TaskViewDelegate: AnyObject {
    func taskView(_ taskView: TaskView, didRequestStateSelectorForTask task: Task)
}
