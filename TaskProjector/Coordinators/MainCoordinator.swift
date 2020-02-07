//
//  MainCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import CoreLocation

class MainCoordinator: Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController

    lazy var addTaskCoordinator = AddTaskCoordinator(
        navigationController: navigationController,
        taskController: taskController)
    lazy var tagsCoordinator = TagsCoordinator(
        navController: navigationController,
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
        addTaskCoordinator.currentState = .title
        addTaskCoordinator.start(withTask: Task())
    }

    func editTask(_ task: Task) {
        addTaskCoordinator.currentState = .all
        addTaskCoordinator.start(withTask: task)
    }

    func viewTags() {
        tagsCoordinator.start()
    }

    func viewNearbyTasks() {
        guard let nearbyTasksVC = NearbyTasksViewController
            .initFromStoryboard(withName: "Main")
            else { return }
        nearbyTasksVC.delegate = self
        navigationController.pushViewController(nearbyTasksVC, animated: true)
    }

    func performUpdates(forTask task: Task, updates: @escaping () throws -> Void) {
        do {
            try taskController.performUpdates(updates)
            try taskController.save(task)
        } catch {
            NSLog("Error performing object updates: \(error)")
        }
    }
}


// MARK: - Nearby Tasks Delegate

extension MainCoordinator: NearbyTasksDelegate {
    func tasksNear(region: CLCircularRegion) -> [Task] {
        taskController.fetchTasksNearby(region)
    }
}
