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
            let cellNib = UINib(nibName: "TaskTableViewCell", bundle: nil)
            tableView.register(
                cellNib,
                forCellReuseIdentifier: TaskTableViewCell.reuseID)
        }
    }

    private var tempTasks: [Task] = [
        Task(name: "Do one thing"),
        Task(name: "Do a different thing"),
        Task(name: "Do a thing with a really, really long name like this that keeps going on and doesn't stop because I just want to know what happens if I do something like this")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

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

        cell.task = tempTasks[indexPath.row]
        cell.updateViews()

        return cell
    }
}
