//
//  TaskView.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

@objc
protocol TaskView {
    func setUp(_ delegate: TaskViewDelegate, forTask task: Task)
    func updateViews()
}
