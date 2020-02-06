//
//  TagsCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import CoreLocation

class TagsCoordinator: Coordinator {
    var navigationController: UINavigationController

    var taskController: TaskController

    var tagCount: Int {
        taskController.allTags?.count ?? 0
    }
    var currentTag: Tag?
    var tagMapAnnotations: [Tag.MapAnnotation] {
        taskController.tagLocationAnnotations
    }

    // MARK: - Init / Start

    init(navController: UINavigationController, taskController: TaskController) {
        self.navigationController = navController
        self.taskController = taskController
    }

    func start() {

    }

    // MARK: - Public Methods

    func tag(forIndexPath indexPath: IndexPath) -> Tag? {
        taskController.allTags?[indexPath.row]
    }

    func viewTagDetails(forIndex indexPath: IndexPath) {

    }

    func setTitle(_ title: String, forTag tag: Tag) {
        
    }

    func editLocation(forTag tag: Tag) {

    }

    func setLocation(_ location: CLLocationCoordinate2D?, forTag tag: Tag? = nil) throws {
        guard let tag = tag ?? currentTag else { return }
        try taskController.performUpdates {
            tag.location = location
        }
        try taskController.saveTag(tag)
    }
}
