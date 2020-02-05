//
//  MainCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController

    lazy var addTaskCoordinator = AddTaskCoordinator(
        navigationController: navigationController,
        taskController: taskController)

    lazy var taskController = TaskController()

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true

        let nextTasksVC = NextTasksViewController()
        navigationController.pushViewController(nextTasksVC, animated: false)
        navigationController.setToolbarHidden(false, animated: false)

        nextTasksVC.delegate = self
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - Next Tasks Delegate

extension MainCoordinator: NextTasksDelegate {

    var nextTasks: [Task] { taskController.nextTasks }

    func requestTaskCreation(_ sender: Any?) {
        addTaskCoordinator.start()
    }

    func editTask(_ task: Task) {
        addTaskCoordinator.currentState = .all
        addTaskCoordinator.start(withTask: task)
    }

    func performUpdates(forTask task: Task, updates: @escaping () throws -> Void) {
        do {
            try taskController.performUpdates(updates)
        } catch {
            NSLog("Error performing object updates: \(error)")
        }
    }
}
