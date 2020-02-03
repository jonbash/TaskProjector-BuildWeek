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

    // TODO: Remove in lieu of model controller
    private var tempTasks: [Task] = {
        let task1 = Task(name: "Do one thing")
        let task2 = Task(name: "Do a different thing")
        let task3 = Task(name: """
            Do a thing with a really, really long name like this that keeps
            going on and doesn't stop because I just want to know what happens
            if I do something like this
        """)

        let homeTag = Tag(name: "Home")
        let workTag = Tag(name: "Work")
        let specialTag = Tag(name: "Special!")

        task1.tags.append(homeTag)
        task2.tags.append(homeTag)
        task2.tags.append(specialTag)
        task3.tags.append(workTag)
        task3.tags.append(specialTag)

        return [task1, task2, task3]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Next Tasks"
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: delegate,
            action: #selector(delegate?.didRequestTaskCreation(_:)))
        setToolbarItems([addButton], animated: false)
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

extension NextTasksViewController: UITableViewDelegate {}

extension NextTasksViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        tempTasks.count
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

        cell.setUp(self, forTask: tempTasks[indexPath.row])

        return cell
    }
}

extension NextTasksViewController: TaskViewDelegate {
    func taskView(
        _ taskView: TaskView,
        didRequestStateSelectorForTask task: Task
    ) {
        presentTaskStateSelector(for: task, withView: taskView)
    }
}
