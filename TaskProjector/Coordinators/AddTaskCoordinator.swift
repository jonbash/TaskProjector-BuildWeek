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
    var addTaskVCs = [TaskCreationState: AddTaskViewController]()

    var taskController: TaskController

    var task: Task?

    // MARK: - Init / Start

    init(navigationController: UINavigationController,
         taskController: TaskController
    ) {
        self.navigationController = navigationController
        self.taskController = taskController
    }

    func start() {
        do {
            task = try taskController.newTask()
        } catch {
            NSLog("Error creating new task: \(error)\nWill make task in memory only.")
            task = Task()
        }
        addViewController(forState: .title)
    }

    // MARK: - Helper Methods

    private func addViewController(forState state: TaskCreationState) {
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
        
    }

    func taskCreatorDidRequestNextState(_ sender: Any) {
        guard let addVC = sender as? AddTaskViewController,
            let newState = TaskCreationState(rawValue: addVC.currentViewState.rawValue + 1)
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
        didChangeValue value: Any,
        forAttribute attribute: TaskCreationState
    ) {
        updateTask { [weak self] in
            switch attribute {
            case .title:
                self?.task?.name = value as? String ?? ""
            case .category:
                self?.task?.parent = value as? Category
            case .timeEstimate:
                self?.task?.timeEstimate = value as? TimeInterval
            case .dueDate:
                self?.task?.dueDate = value as? Date
            case .all:
                break
            }
        }
    }

    func taskCreatorDidRequestTaskSave(_ sender: Any) {
        guard let task = task else {
            NSLog("Error saving task: Task unexpectedly nil")
            return
        }
        do {
            try taskController.saveTask(task)
        } catch {
            NSLog("Error saving task \(task): \(error)")
        }
    }
}
