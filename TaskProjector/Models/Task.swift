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
class Task: Object, Category {

    // MARK: - Persisted : Public

    dynamic var name: String
    private(set) dynamic var identifier: String
    dynamic var notes: String = ""
    var tags = List<Tag>()

    dynamic var dueDate: Date?
    dynamic var deferDate: Date?
    dynamic var scheduledDate: Date?
    dynamic var modifiedDate: Date?
    dynamic var completionDate: Date?

    dynamic var isProject: Bool
    dynamic var childTasks = LinkingObjects(fromType: Task.self,
                                            property: "parentProject") {
        didSet {
            if childTasks.isEmpty {
                _taskGroupType = nil
            } else if !childTasks.isEmpty && _taskGroupType == nil {
                _taskGroupType = TaskGroupType.parallel.rawValue
            }
        }
    }

    // MARK: Private

    private dynamic var _state: String = CompletableState.active.rawValue
    private(set) dynamic var parentProject: Task?
    private(set) dynamic var parentArea: Area?
    private var _timeEstimate = RealmOptional<Double>()
    private dynamic var _taskGroupType: String?

    // MARK: - Public Computed

    var taskGroupType: TaskGroupType? {
        get {
            if childTasks.isEmpty {
                return nil
            } else {
                guard let groupTypeString = _taskGroupType,
                    let groupType = TaskGroupType(rawValue: groupTypeString)
                    else { return .parallel }
                return groupType
            }
        }
        set {
            _taskGroupType = (childTasks.isEmpty) ? nil : newValue?.rawValue
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
    var parent: Category? {
        get { parentProject ?? parentArea }
        set {
            parentProject = newValue as? Task
            parentArea = newValue as? Area
        }
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
