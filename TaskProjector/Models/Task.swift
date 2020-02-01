//
//  Task.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Task: Object, Completable {
    dynamic var name: String = ""
    dynamic let identifier: String = UUID().uuidString
    dynamic var parent: Category?
    dynamic var dueDate: Date?
    dynamic var timeEstimate: TimeInterval?
    dynamic var completionDate: Date?

    func activate() {

    }

    func complete() {

    }

    func drop() {

    }

    func placeOnHold() {

    }
}
