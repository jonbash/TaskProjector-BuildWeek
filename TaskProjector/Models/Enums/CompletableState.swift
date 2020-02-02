//
//  CompletableState.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

enum CompletableState: String {
    case active = "Active"
    case onHold = "On Hold"
    case done = "Done"
    case dropped = "Dropped"

    // TODO: Unit test assert not-nil for each
    var image: UIImage {
        let imageName: String = {
            switch self {
            case .active: return "square"
            case .onHold: return "lessthan.square"
            case .done: return "checkmark.square"
            case .dropped: return "xmark.square"
            }
        }()
        return UIImage(systemName: imageName)!
    }

    // TODO: Unit test assert not-nil for each
    var color: UIColor {
        // TODO:
        let colorName: String = {
            switch self {
            case .active: return "TaskActive"
            case .onHold: return "TaskInactive"
            case .done: return "TaskInactive"
            case .dropped: return "TaskInactive"
            }
        }()
        return UIColor(named: colorName)!
    }
}
