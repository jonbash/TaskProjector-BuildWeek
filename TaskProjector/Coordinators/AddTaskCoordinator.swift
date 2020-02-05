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

    var currentState: NewTaskAttribute = .title
    var amEditing: Bool = false

    var taskController: TaskController
    private(set) var task = Task()

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
        guard let newVC: AddTaskViewController = {
            switch state {
            case .title:
                return viewController(ofType: TaskTitleViewController.self)
            case .category:
                return viewController(ofType: TaskCategoryViewController.self)
            case .timeEstimate:
                return viewController(ofType: TaskTimeEstimateViewController.self)
            case .dueDate:
                return viewController(ofType: TaskDueDateViewController.self)
            case .tag:
                return viewController(ofType: TaskTagViewController.self)
            case .all:
                return viewController(ofType: TaskEditAllViewController.self)
            }
        }() else { return }

        newVC.taskCreationClient = self
        navigationController.pushViewController(newVC, animated: true)
    }

    private func updateTask(updates: @escaping () -> Void) {
        do {
            try taskController.performUpdates(updates)
        } catch {
            NSLog("Error performing updates on task: \(error)")
        }
    }

    private func viewController<AddTaskVC>(
        ofType type: AddTaskVC.Type
    ) -> AddTaskVC? where AddTaskVC: AddTaskViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: String(describing: AddTaskVC.self))
            as? AddTaskVC
    }
}

// MARK: - Task Creation Client

extension AddTaskCoordinator: TaskCreationClient {
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType) {
        // TODO: implement this method
    }

    func requestNextCreationStep(_ sender: Any) {
        currentState = {
            if let titleVC = sender as? TaskTitleViewController {
                task.name = titleVC.taskTitle
                return .title
            } else if let categoryVC = sender as? TaskCategoryViewController {
                task.parent = categoryVC.category
                return .category
            } else if let timeEstVC = sender as? TaskTimeEstimateViewController {
                task.timeEstimate = timeEstVC.timeEstimate
                return .timeEstimate
            } else if let dueDateVC = sender as? TaskDueDateViewController {
                task.dueDate = dueDateVC.dueDate
                return .dueDate
            } else if let tagVC = sender as? TaskTagViewController {
                if let tag = tagVC.tag { task.tagsAsArray = [tag] }
                return .tag
            } else {
                return currentState
            }
        }()
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
            try taskController.saveTask(task)
        } catch {
            NSLog("Error saving task \(task): \(error)")
        }
        navigationController.popToRootViewController(animated: true)
    }

    // MARK: - Editing

    func editTask(attribute: NewTaskAttribute) {
        amEditing = true
        currentState = attribute
        addViewController(forState: currentState)
    }

    func finishEditing() {
        amEditing = false
        currentState = .all
    }
}
