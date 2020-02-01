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

    // MARK: - Backing/Persisted

    private dynamic var _state: String = CompletableState.active.rawValue
    private dynamic var parentProject: Project?
    private dynamic var parentArea: Area?
    private dynamic var _timeEstimate = RealmOptional<Double>()

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
}


extension Task: Completable {

    // MARK: - Completable Computed

    private(set) var state: CompletableState {
        get { CompletableState(rawValue: _state) ?? .active }
        set { _state = newValue.rawValue }
    }

    var parent: Category? {
        get { parentProject ?? parentArea }
        set {
            if let newProject = newValue as? Project {
                parentProject = newProject
            } else if let newArea = newValue as? Area {
                parentArea = newArea
            }
        }
    }

    var timeEstimate: TimeInterval? {
        get { _timeEstimate.value }
        set { _timeEstimate.value = newValue }
    }

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
