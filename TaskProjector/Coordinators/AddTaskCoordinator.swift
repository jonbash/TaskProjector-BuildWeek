//
//  AddTaskCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class AddTaskCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var addTaskVCs = [NewTaskAttribute: AddTaskViewController]()

    var taskController: TaskController
    var task = Task()

    private(set) lazy var categoryPickerDataSource: CategoryPickerDataSource = {
        CategoryPickerDataSource(taskController: taskController)
    }()
    private(set) lazy var tagPickerDataSource: TagPickerDataSource = {
        TagPickerDataSource(taskController: taskController)
    }()

    // MARK: - Init / Start

    init(navigationController: UINavigationController,
         taskController: TaskController
    ) {
        self.navigationController = navigationController
        self.taskController = taskController
    }

    func start() {
        task = Task()
        addViewController(forState: .title)
    }

    // MARK: - Helper Methods

    private func addViewController(forState state: NewTaskAttribute) {
        let newVC = AddTaskViewController(state: state, client: self)
        addTaskVCs[state] = newVC

        navigationController.pushViewController(newVC, animated: true)
    }

    private func updateTask(updates: @escaping () -> Void) {
        do {
            try taskController.performUpdates(updates)
        } catch {
            NSLog("Error performing updates on task: \(error)")
        }
    }
}

// MARK: - Task Creation Client

extension AddTaskCoordinator: TaskCreationClient {
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType) {
        // TODO: implement this method
    }

    func taskCreatorDidRequestNextState(_ sender: Any) {
        guard let addVC = sender as? AddTaskViewController,
            let newState = NewTaskAttribute(rawValue: addVC.taskAttribute.rawValue + 1)
            else { return }
        addViewController(forState: newState)
    }

    @objc func taskCreatorDidRequestPrevState(_ sender: Any) {
        navigationController.popViewController(animated: true)
    }

    func taskCreatorDidCancel(_ sender: Any) {
        navigationController.popToRootViewController(animated: true)
    }

    // MARK: - Task Building

    func taskCreator(
        _ sender: Any,
        didSetValue value: Any?,
        forAttribute attribute: NewTaskAttribute
    ) {
        updateTask { [weak self] in
            switch attribute {
            case .title:
                self?.task.name = value as? String ?? ""
            case .category:
                self?.task.parent = value as? Category
            case .timeEstimate:
                self?.task.timeEstimate = value as? TimeInterval
            case .dueDate:
                self?.task.dueDate = value as? Date
            case .tag:
                if let tag = value as? Tag {
                    self?.task.tagsAsArray = [tag]
                } else { self?.task.tagsAsArray = [] }
            case .all: break
            }
        }
    }

    func taskCreatorDidRequestTaskSave(_ sender: Any) {
        do {
            try taskController.saveTask(task)
        } catch {
            NSLog("Error saving task \(task): \(error)")
        }
        navigationController.popToRootViewController(animated: true)
    }
}
