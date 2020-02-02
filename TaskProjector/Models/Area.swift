//
//  Area.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Area: Object, Category {
    dynamic var name: String = ""
    private(set) dynamic var identifier: String = UUID().uuidString
    dynamic var children = List<Task>()

    convenience init(name: String = "", identifier: String = UUID().uuidString) {
        self.init()
        self.name = name
        self.identifier = identifier
    }

    func addChild(_ task: Task) {
        children.append(task)
    }
}
