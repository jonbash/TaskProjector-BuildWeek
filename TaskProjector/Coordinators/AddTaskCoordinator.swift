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
        navigationController.pushViewController(addTaskVCs[.title]!, animated: true)
    }

    private func addViewController(forState state: TaskCreationState) {
        addTaskVCs[state] = AddTaskViewController(state: state, client: self)
    }
}

extension AddTaskCoordinator: TaskCreationClient {
    func taskCreatorDidRequestTaskSave(_ sender: Any) {

    }

    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType) {
        
    }

    func taskCreator(_ sender: Any, didRequestNextState: Bool) {

    }
}
