//
//  NextTasksDelegate.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

@objc
protocol NextTasksDelegate {
    func didRequestTaskCreation(_ sender: Any?)
}
