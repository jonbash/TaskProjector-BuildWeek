//
//  TagsCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TagsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var taskController: TaskController

    var tagCount: Int {
        taskController.allTags?.count ?? 0
    }

    init(navController: UINavigationController, taskController: TaskController) {
        self.navigationController = navController
        self.taskController = taskController
    }

    func start() {

    }

    func tag(forIndexPath indexPath: IndexPath) -> Tag? {
        taskController.allTags?[indexPath.row]
    }

    func viewTagDetails(forIndex indexPath: IndexPath) {

    }
}
