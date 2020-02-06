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

    var tagsTableVC: TagsTableViewController?
    var tagDetailVC: TagDetailViewController?
    var tagMapVC: TagMapViewController?

    var taskController: TaskController

    var currentTag: Tag?
    var tagCount: Int {
        taskController.allTags?.count ?? 0
    }
    var tagMapAnnotations: [Tag.MapAnnotation] {
        taskController.tagLocationAnnotations
    }

    // MARK: - Init / Start

    init(navController: UINavigationController, taskController: TaskController) {
        self.navigationController = navController
        self.taskController = taskController
    }

    func start() {
        guard let tagsVC = tagsTableVC ?? TagsTableViewController
            .initFromStoryboard(withName: "Main")
            else {
                NSLog("Error starting TagsCoordinator; couldn't initialize TagsTableVC from storyboard")
                return
        }
        tagsVC.tagsCoordinator = self
        push(tagsVC)
    }

    // MARK: - Transition Methods

    func viewTagDetails(forIndex indexPath: IndexPath) {
        if tagDetailVC == nil {
            tagDetailVC = TagDetailViewController
                .initFromStoryboard(withName: "Main")
        }
        guard
            let tag = tag(forIndexPath: indexPath),
            let detailVC = tagDetailVC
            else { return }
        currentTag = tag
        detailVC.tag = tag
        detailVC.tagsCoordinator = self
        push(detailVC)
    }

    func editLocation(forTag tag: Tag? = nil) {
        if tagMapVC == nil {
            tagMapVC = TagMapViewController
                .initFromStoryboard(withName: "Main")
        }
        guard
            let tag = tag ?? currentTag,
            let mapVC = tagMapVC
            else { return }
        mapVC.tagsCoordinator = self
        mapVC.editingTag = tag
        push(mapVC)
    }

    // MARK: - Child API

    func tag(forIndexPath indexPath: IndexPath) -> Tag? {
        taskController.allTags?[indexPath.row]
    }

    func setTagTitle(_ title: String, tag: Tag? = nil) throws {
        guard let tag = tag ?? currentTag else { return }
        try taskController.performUpdates {
            tag.name = title
        }
        try taskController.saveTag(tag)
    }

    func setTagLocation(_ location: CLLocationCoordinate2D?, tag: Tag? = nil) throws {
        guard let tag = tag ?? currentTag else { return }
        try taskController.performUpdates {
            tag.location = location
        }
        try taskController.saveTag(tag)
    }

    // MARK: - Private Helpers

    private func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
