//
//  Project.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Project: Object {
    var name: String = ""
    var identifier: String = UUID().uuidString
    var parent: Category?
    var dueDate: Date?
    var timeEstimate: TimeInterval?
    var completionDate: Date?

    func makeActive() {

    }

    func complete() {

    }

    func drop() {

    }

    func placeOnHold() {

    }
}

extension Project: Completable {
    var children: [Completable] {
        get {}
        set {}
    }

}

extension Project: Category {

}
