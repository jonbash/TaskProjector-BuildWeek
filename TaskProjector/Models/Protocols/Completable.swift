//
//  Completable.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol Completable {
    var name: String { get set }
    var identifier: String { get }
    var state: CompletableState { get }
    var parent: Category? { get set }
    var dueDate: Date? { get set }
    var timeEstimate: TimeInterval? { get set }
    var completionDate: Date? { get }

    func makeActive()
    func complete()
    func drop()
    func placeOnHold()
}
