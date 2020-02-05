//
//  DueState.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

enum DueState {
    case notDueSoon
    case dueSoon
    case dueVerySoon
    case overdue

    var color: UIColor? {
        switch self {
        case .dueSoon: return .systemYellow
        case .dueVerySoon: return .systemOrange
        case .overdue: return .systemRed
        default: return nil
        }
    }
}
