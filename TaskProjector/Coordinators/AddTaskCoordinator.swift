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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
    func taskCreatorDidRequestTaskSave(_ sender: Any) {

    }

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
}
