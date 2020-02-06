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

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var tasksTableView: UITableView!
    @IBOutlet private weak var locationSwitch: UISwitch!
    @IBOutlet private weak var editLocationButton: UIButton!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tag Details"
        tasksTableView.register(
            UINib(nibName: "TaskTableViewCell", bundle: nil),
            forCellReuseIdentifier: TaskTableViewCell.reuseID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleField.text = tag.name
        locationSwitch.isOn = tag.location != nil
        setLocationButtonHidden()
        tasksTableView.reloadData()
    }

    // MARK: - Actions

    @IBAction func editLocationTapped(_ sender: UIButton) {
        tagsCoordinator?.editLocation(forTag: tag)
    }

    @IBAction func locationSwitchToggled(_ sender: UISwitch) {
        setLocationButtonHidden()
    }

    private func setLocationButtonHidden() {
        editLocationButton.isHidden = !locationSwitch.isOn
    }
}

// MARK: - Text Field Delegate

extension TagDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
            guard let title = textField.text, !title.isEmpty else {
                return false
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            do {
                try tagsCoordinator.setTagTitle(titleField.text ?? tag.name,
                                                tag: tag)
            } catch {
                NSLog("Error setting tag title: \(error)")
            }
        }
    }
}

// MARK: - TableView Delegate/DataSource

extension TagDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
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

// MARK: - Task View Delegate

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
