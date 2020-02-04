//
//  NewTaskAttribute.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

@objc
enum NewTaskAttribute: Int {
    case title
    case category
    case timeEstimate
    case dueDate
    case tag
    case all

    func viewTitleForNewTaskState() -> String {
        let suffix: String
        switch self {
        case .title: suffix = "Title"
        case .category: suffix = "Category"
        case .timeEstimate: suffix = "Time estimate"
        case .dueDate: suffix = "Due date"
        case .tag: suffix = "Tag"
        case .all: suffix = "Save?"
        }
        return "New task - \(suffix)"
    }
}
