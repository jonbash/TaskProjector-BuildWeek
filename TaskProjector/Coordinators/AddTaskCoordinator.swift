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
        let vcType: AddTaskViewController.Type = {
            switch state {
            case .title: return TaskTitleViewController.self
            case .category: return TaskCategoryViewController.self
            case .timeEstimate: return TaskTimeEstimateViewController.self
            case .dueDate: return TaskDueDateViewController.self
            case .tag: return TaskTagViewController.self
            case .all: return TaskEditAllViewController.self
            }
        }()
        guard let newVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(
                withIdentifier: String(describing: vcType.self))
            as? AddTaskViewController
            else { return }
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
}

// MARK: - Task Creation Client

extension AddTaskCoordinator: TaskCreationClient {
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType) {
        // TODO: implement this method
    }

    func requestNextCreationStep(_ sender: Any) {
        currentState = {
            if let _ = sender as? TaskTitleViewController {
                return .title
            } else if let _ = sender as? TaskCategoryViewController {
                return .category
            } else if let _ = sender as? TaskTimeEstimateViewController {
                return .timeEstimate
            } else if let _ = sender as? TaskDueDateViewController {
                return .dueDate
            } else if let _ = sender as? TaskTagViewController {
                return .tag
            } else {
                return currentState
            }
        }()
        currentState.tryIncrement()

        addViewController(forState: currentState)
    }

    @objc func taskCreatorDidRequestPrevState(_ sender: Any) {
        navigationController.popViewController(animated: true)
    }

    func cancelTaskCreation(_ sender: Any) {
        navigationController.popToRootViewController(animated: true)
    }

    // MARK: Task Building

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

    func requestTaskSave(_ sender: Any) {
        do {
            try taskController.saveTask(task)
        } catch {
            NSLog("Error saving task \(task): \(error)")
        }
        navigationController.popToRootViewController(animated: true)
    }
}
