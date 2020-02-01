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
    var childCoordinators = [Coordinator]()

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true

        let nextTasksVC = NextTasksViewController()
        navigationController.pushViewController(nextTasksVC, animated: false)
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
