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
        setUpViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setUpViews() {
        title = "Next Tasks"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(createTask(_:)))
        let tagsButton = UIBarButtonItem(title: "Tags",
                                         style: .plain,
                                         target: self,
                                         action: #selector(viewTags(_:)))
        setToolbarItems([addButton, tagsButton], animated: false)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(refreshTableView(_:)),
                                            for: .valueChanged)
    }

    // MARK: - Methods

    @objc
    func createTask(_ sender: Any) {
        delegate?.requestTaskCreation(self)
    }

    @objc
    func viewTags(_ sender: Any) {
        delegate?.viewTags()
    }

    @objc
    func refreshTableView(_ sender: Any) {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
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
                    self.delegate?.performUpdates(forTask: task, updates: {
                        task.state = state
                    })
                    DispatchQueue.main.async { taskView.updateViews() }
            }))
        }
        alert.addAction(.cancel)
        present(alert, animated: true)
    }
}

// MARK: - TableView

extension NextTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let task = delegate?.nextTasks[indexPath.row] else { return }
        delegate?.editTask(task)
    }
}

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
            for: indexPath)
            as? TaskTableViewCell ?? TaskTableViewCell(
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
