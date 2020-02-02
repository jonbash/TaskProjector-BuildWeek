//
//  Task.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift


class Task: Object, Category {

    // MARK: - Persisted
    // MARK: Public

    @objc dynamic var name: String
    @objc private(set) dynamic var identifier: String
    @objc dynamic var notes: String = ""
    var tags = List<Tag>()

    @objc dynamic var dueDate: Date?
    @objc dynamic var deferDate: Date?
    @objc dynamic var scheduledDate: Date?
    @objc dynamic var modifiedDate: Date?
    @objc dynamic var completionDate: Date?

    @objc dynamic var isProject: Bool
    dynamic var children = List<Task>() {
        didSet {
            if children.isEmpty {
                _taskGroupType = nil
            } else if !children.isEmpty && _taskGroupType == nil {
                _taskGroupType = TaskGroupType.parallel.rawValue
            }
        }
    }

    // MARK: Private

    @objc private dynamic var _state: String = CompletableState.active.rawValue
    @objc private dynamic var parentProject: Task?
    @objc private dynamic var parentArea: Area?
    private var _timeEstimate = RealmOptional<Double>()
    @objc private dynamic var _taskGroupType: String?

    // MARK: - Public Computed

    var taskGroupType: TaskGroupType? {
        get {
            if children.isEmpty {
                return nil
            } else {
                guard let groupTypeString = _taskGroupType,
                    let groupType = TaskGroupType(rawValue: groupTypeString)
                    else { return .parallel }
                return groupType
            }
        }
        set {
            _taskGroupType = (children.isEmpty) ? nil : newValue?.rawValue
        }
    }
    var state: CompletableState {
        get { CompletableState(rawValue: _state) ?? .active }
        set { _state = newValue.rawValue }
    }
    var timeEstimate: TimeInterval? {
        get { _timeEstimate.value }
        set { _timeEstimate.value = newValue }
    }

    // MARK: - Init

    convenience init(name: String, identifier: String = UUID().uuidString, isProject: Bool = false) {
        self.init()
        self.name = name
        self.identifier = identifier
        self.isProject = isProject
    }

    required init() {
        self.name = ""
        self.identifier = UUID().uuidString
        self.isProject = false
        super.init()
    }

    // MARK: - Overrides

    override var description: String {
        "\"\(name)\" - \(state) task (\(identifier))"
    }

    override static func primaryKey() -> String? { "identifier" }

    // MARK: - Methods

    func toggleComplete() {
        state = (state == .active || state == .onHold) ? .done : .active
    }
}
