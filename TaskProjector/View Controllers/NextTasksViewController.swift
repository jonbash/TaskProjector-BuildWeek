//
//  NextTasksViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class NextTasksViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(
                UINib(nibName: "TaskTableViewCell", bundle: nil),
                forCellReuseIdentifier: TaskTableViewCell.reuseID)
        }
    }

    weak var delegate: NextTasksDelegate?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Next Tasks"
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createTask(_:)))
        setToolbarItems([addButton], animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Methods

    @objc
    func createTask(_ sender: Any) {
        delegate?.didRequestTaskCreation(self)
    }

    func presentTaskStateSelector(
        for task: Task,
        withView taskView: TaskView
    ) {
        let alert = UIAlertController(title: "Change task state",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        for state in CompletableState.allCases {
            alert.addAction(UIAlertAction(
                title: state.rawValue,
                style: .default,
                handler: { _ in
                    task.state = state
                    DispatchQueue.main.async { taskView.updateViews() }
            }))
        }
        alert.addAction(.cancel)
        present(alert, animated: true)
    }
}

// MARK: - TableView

extension NextTasksViewController: UITableViewDelegate {}

extension NextTasksViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        delegate?.nextTasks.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.reuseID,
            for: indexPath
            ) as? TaskTableViewCell
            ?? TaskTableViewCell(
                style: .default,
                reuseIdentifier: TaskTableViewCell.reuseID)

        guard let delegate = delegate else { return cell }
        cell.setUp(self, forTask: delegate.nextTasks[indexPath.row])
        return cell
    }
}

// MARK: - TaskViewDelegate

extension NextTasksViewController: TaskViewDelegate {
    func taskView(
        _ taskView: TaskView,
        didRequestStateSelectorForTask task: Task
    ) {
        presentTaskStateSelector(for: task, withView: taskView)
    }

    func taskView(
        _ taskView: TaskView,
        willPerformUpdatesforTask task: Task,
        updates: @escaping () throws -> Void
    ) {
        delegate?.performUpdates(forTask: task, updates: updates)
    }
}
