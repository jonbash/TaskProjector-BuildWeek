//
//  Area.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

class Area: Object, Category {
    @objc dynamic var name: String = ""
    @objc private(set) dynamic var identifier: String = UUID().uuidString

    let childTasks = LinkingObjects(fromType: Task.self,
                                    property: "parentArea")

    @objc dynamic var parent: Area?
    let childAreas = LinkingObjects(fromType: Area.self,
                                    property: "parent")

    convenience init(name: String = "", identifier: String = UUID().uuidString) {
        self.init()
        self.name = name
        self.identifier = identifier
    }

    override var description: String { "Area \"\(name)\" (\(identifier))" }
    
    override static func primaryKey() -> String? { "identifier" }
}
