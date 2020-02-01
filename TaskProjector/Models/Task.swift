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
class Task: Object {

    // MARK: - Public/Persisted

    dynamic var name: String
    private(set) dynamic var identifier: String
    dynamic var dueDate: Date?
    dynamic var completionDate: Date?
    dynamic var children = List<Task>()

    // MARK: - Backing/Persisted

    private dynamic var _state: String = CompletableState.active.rawValue
    private dynamic var parentProject: Task?
    private dynamic var parentArea: Area?
    private var _timeEstimate = RealmOptional<Double>()
    private var _taskGroupType = RealmOptional<TaskGroupType>()

    // MARK: - Public/Computed

    var taskGroupType: TaskGroupType? {
        get { _taskGroupType.value }
        set { _taskGroupType.value = newValue }
    }
    private(set) var state: CompletableState {
        get { CompletableState(rawValue: _state) ?? .active }
        set { _state = newValue.rawValue }
    }
    var timeEstimate: TimeInterval? {
        get { _timeEstimate.value }
        set { _timeEstimate.value = newValue }
    }

    // MARK: - Init

    convenience init(name: String, identifier: String = UUID().uuidString) {
        self.init()
        self.name = name
        self.identifier = identifier
    }

    required init() {
        self.name = ""
        self.identifier = UUID().uuidString
        super.init()
    }

    // MARK: - Overrides

    override var description: String {
        "Task \(identifier) - \"\(name)\" - \(state)"
    }

    override static func primaryKey() -> String? { "identifier" }

    // MARK: - Completable Methods

    func makeActive() {

    }

    func complete() {

    }

    func drop() {

    }

    func placeOnHold() {

    }
}
