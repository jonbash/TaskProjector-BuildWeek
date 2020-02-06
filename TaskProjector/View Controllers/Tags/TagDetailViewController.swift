//
//  TagDetailViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TagDetailViewController: UIViewController {

    weak var tagsCoordinator: TagsCoordinator!
    weak var tag: Tag!

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var editLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.register(
            UINib(nibName: "TaskTableViewCell", bundle: nil),
            forCellReuseIdentifier: TaskTableViewCell.reuseID)
    }

    @IBAction func editLocationTapped(_ sender: UIButton) {
        tagsCoordinator?.editLocation(forTag: tag)
    }
}

extension TagDetailViewController: UITableViewDelegate {

}

extension TagDetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        tag.tasks.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.reuseID,
            for: indexPath)
            as? TaskTableViewCell ?? TaskTableViewCell(
                style: .default,
                reuseIdentifier: TaskTableViewCell.reuseID)
        
        cell.setUp(self, forTask: tag.tasks[indexPath.row])
        return cell
    }
}

extension TagDetailViewController: TaskViewDelegate {
    func taskView(_ taskView: TaskView, didRequestStateSelectorForTask task: Task) {
        let alert = UIAlertController(title: "Change task state",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        for state in CompletableState.allCases {
            alert.addAction(UIAlertAction(
                title: state.rawValue,
                style: .default,
                handler: { _ in
                    self.taskView(taskView, willPerformUpdatesforTask: task) {
                        task.state = state
                    }
            }))
        }
        alert.addAction(.cancel)
        present(alert, animated: true)
    }

    func taskView(_ taskView: TaskView, willPerformUpdatesforTask task: Task, updates: @escaping () throws -> Void) {
        do {
            try self.tagsCoordinator.taskController.performUpdates(updates)
        } catch {
            NSLog("Error modifying task: \(error)")
        }
        DispatchQueue.main.async { taskView.updateViews() }
    }
}
