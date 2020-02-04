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

    var task: Task!

    init(navigationController: UINavigationController,
         taskController: TaskController
    ) {
        self.navigationController = navigationController
        self.taskController = taskController
        do {
            task = try taskController.newTask()
        } catch {
            NSLog("Error creating new task: \(error)")
        }
    }

    func start() {
        addViewController(forState: .title)
    }

    private func addViewController(forState state: TaskCreationState) {
        let newVC = AddTaskViewController(state: state, client: self)
        addTaskVCs[state] = newVC

        navigationController.pushViewController(newVC, animated: true)
    }
}

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

    func taskCreator(_ sender: Any, didChooseTitle title: String) {
        task.name = title
    }

    func taskCreator(_ sender: Any, didChooseProject project: Task?) {
        task.parent = project
    }

    func taskCreator(_ sender: Any, didChooseArea area: Area?) {
        task.parent = area
    }

    func taskCreator(_ sender: Any, didChooseTimeEstimate timeEstimate: TimeInterval) {
        task.timeEstimate = timeEstimate
    }

    func taskCreatorDidSelectNoTimeEstimate(_ sender: Any) {
        task.timeEstimate = nil
    }

    func taskCreator(_ sender: Any, didChooseDueDate dueDate: Date?) {
        task.dueDate = dueDate
    }

    func taskCreatorDidRequestTaskSave(_ sender: Any) {

    }
}
