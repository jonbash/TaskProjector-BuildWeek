//
//  AddTaskCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class AddTaskCoordinator: Coordinator {
    var navigationController: UINavigationController
    var addTaskVCs = [NewTaskAttribute: AddTaskViewController]()

    var currentState: NewTaskAttribute = .title
    var amEditing: Bool = false

    var taskController: TaskController
    private(set) var task = Task()

    private(set) lazy var categoryPickerDataSource =
        CategoryPickerDataSource(taskController: taskController)
    private(set) lazy var tagPickerDataSource =
        TagPickerDataSource(taskController: taskController)

    // MARK: - Init / Start

    init(navigationController: UINavigationController,
         taskController: TaskController
    ) {
        self.navigationController = navigationController
        self.taskController = taskController
    }

    func start() {
        start(withTask: Task())
    }

    func start(withTask task: Task) {
        self.task = task
        addViewController(forState: currentState)
    }

    // MARK: - Helper Methods

    private func addViewController(forState state: NewTaskAttribute) {
        guard let newVC: AddTaskViewController = {
            let mainSB = "Main"
            switch state {
            case .title:
                return TaskTitleViewController.initFromStoryboard(withName: mainSB)
            case .category:
                return TaskCategoryViewController.initFromStoryboard(withName: mainSB)
            case .timeEstimate:
                return TaskTimeEstimateViewController.initFromStoryboard(withName: mainSB)
            case .dueDate:
                return TaskDueDateViewController.initFromStoryboard(withName: mainSB)
            case .tag:
                return TaskTagViewController.initFromStoryboard(withName: mainSB)
            case .all:
                return TaskEditAllViewController.initFromStoryboard(withName: mainSB)
            }
        }() else { return }

        newVC.creationClient = self
        newVC.editingClient = self
        navigationController.pushViewController(newVC, animated: true)
    }

    private func updateTask(updates: @escaping () -> Void) {
        do {
            try taskController.performUpdates(updates)
        } catch {
            NSLog("Error performing updates on task: \(error)")
        }
    }

    @discardableResult
    private func pullAttributes(fromVC addTaskVC: AddTaskViewController?
    ) -> NewTaskAttribute {
        if let titleVC = addTaskVC as? TaskTitleViewController {
            updateTask { self.task.name = titleVC.taskTitle }
            return .title
        } else if let categoryVC = addTaskVC as? TaskCategoryViewController {
            updateTask { self.task.parent = categoryVC.category }
            return .category
        } else if let timeEstVC = addTaskVC as? TaskTimeEstimateViewController {
            updateTask { self.task.timeEstimate = timeEstVC.timeEstimate }
            return .timeEstimate
        } else if let dueDateVC = addTaskVC as? TaskDueDateViewController {
            updateTask { self.task.dueDate = dueDateVC.dueDate }
            return .dueDate
        } else if let tagVC = addTaskVC as? TaskTagViewController {
            updateTask {
                if let tag = tagVC.tag {
                    self.task.tagsAsArray = [tag]
                } else {
                    self.task.tagsAsArray = []
                }
            }
            return .tag
        } else {
            return currentState
        }
    }
}

// MARK: - Task Creation Client

extension AddTaskCoordinator: TaskCreationClient {
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType) {
        // TODO: implement this method
    }

    func requestNextCreationStep(_ sender: Any) {
        currentState = pullAttributes(fromVC: sender as? AddTaskViewController)
        currentState.tryIncrement()

        addViewController(forState: currentState)
    }

    func taskCreatorDidRequestPrevState(_ sender: Any) {
        navigationController.popViewController(animated: true)
    }

    func cancelTaskCreation(_ sender: Any) {
        navigationController.popToRootViewController(animated: true)
    }

    func requestTaskSave(_ sender: Any) {
        do {
            try taskController.save(task)
        } catch {
            NSLog("Error saving task \(task): \(error)")
        }
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - Task Editing Client

extension AddTaskCoordinator: TaskEditingClient {
    func editTask(attribute: NewTaskAttribute) {
        amEditing = true
        currentState = attribute
        addViewController(forState: currentState)
    }

    func finishEditing(_ sender: Any) {
        amEditing = false
        currentState = .all
        if let addVC = sender as? AddTaskViewController {
            pullAttributes(fromVC: addVC)
        }
    }
}
