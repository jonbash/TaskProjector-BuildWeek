//
//  AddEditTaskOrigin.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-15.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol AddEditTaskOrigin {
    func newTask()
    func editTask(_ task: Task)
}
