//
//  Category.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import RealmSwift

protocol Category {
    var name: String { get set }
    var identifier: String { get }
    var childTasks: LinkingObjects<Task> { get }
}
