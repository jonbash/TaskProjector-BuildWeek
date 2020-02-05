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
    var tagsAsArray: [Tag] {
        get {
            var array = [Tag]()
            tags.forEach { array.append($0) }
            return array
        }
        set {
            let newTags = List<Tag>()
            newValue.forEach { newTags.append($0) }
            tags = newTags
        }
    }

    // MARK: - Private Computed
    private var dueDateUrgencyModifier: Double {
        /*
         1 year: 0
         1 month: 5
         1 week: 10
         1 day: 15
         now: 20
         -year: 40
         */
        guard let dueDate = dueDate else { return 0 }
        let timeDist = dueDate.timeIntervalSinceNow
        if timeDist.years < 1 && timeDist.months >= 1 {
            return Rescaler(
                from: (lowerBound: TimeInterval(years: 1),
                       upperBound: TimeInterval(months: 1)),
                to: (lowerBound: 0,
                     upperBound: 5))
                .rescale(timeDist)
        } else if timeDist.months < 1 && timeDist.weeks >= 1 {
            return Rescaler(
                from: (lowerBound: TimeInterval(months: 1),
                       upperBound: TimeInterval(weeks: 1)),
                to: (lowerBound: 5,
                     upperBound: 10))
                .rescale(timeDist)
        } else if timeDist.weeks < 1 && timeDist.days >= 1 {
            return Rescaler(
                from: (lowerBound: TimeInterval(weeks: 1),
                       upperBound: TimeInterval(days: 1)),
                to: (lowerBound: 10,
                     upperBound: 15))
                .rescale(timeDist)
        } else if timeDist.days < 1 && timeDist >= 0 {
            return Rescaler(
                from: (lowerBound: TimeInterval(days: 1),
                       upperBound: 0),
                to: (lowerBound: 15,
                     upperBound: 20))
                .rescale(timeDist)
        } else if timeDist.days < 0 && timeDist.years >= -1 {
            return Rescaler(
                from: (lowerBound: 0,
                       upperBound: TimeInterval(years: -1)),
                to: (lowerBound: 20,
                     upperBound: 40))
                .rescale(timeDist)
        } else if timeDist.years < -1 {
            return 40
        } else {
            return 0
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
