//
//  CompletableState.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

enum CompletableState: String, CaseIterable {
    case active = "Active"
    case onHold = "On Hold"
    case done = "Done"
    case dropped = "Dropped"

    // TODO: Unit test assert not-nil for each
    var image: UIImage? {
        let imageName: String = {
            switch self {
            case .active: return "square"
            case .onHold: return "lessthan.square"
            case .done: return "checkmark.square"
            case .dropped: return "xmark.square"
            }
        }()
        return UIImage(systemName: imageName)

    }

    // TODO: Unit test assert not-nil for each
    var color: UIColor {
        switch self {
        case .active: return #colorLiteral(red: 0.4690000117, green: 0.6169999838, blue: 0.5070000291, alpha: 1)
        case .onHold: return #colorLiteral(red: 0.7059999704, green: 0.7450000048, blue: 0.8320000172, alpha: 1)
        case .done: return #colorLiteral(red: 0.7059999704, green: 0.7450000048, blue: 0.8320000172, alpha: 1)
        case .dropped: return #colorLiteral(red: 0.7059999704, green: 0.7450000048, blue: 0.8320000172, alpha: 1)
        }
    }
}
