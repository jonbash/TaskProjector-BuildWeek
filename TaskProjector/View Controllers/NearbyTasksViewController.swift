//
//  NearbyTasksViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-06.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import CoreLocation


protocol NearbyTasksDelegate: AnyObject {
    func tasksNear(region: CLCircularRegion) -> [Task]
    func performUpdates(forTask task: Task, updates: @escaping () throws -> Void)
}


class NearbyTasksViewController: UITableViewController {

    weak var delegate: NearbyTasksDelegate?
    lazy var locationHelper = LocationHelper()
    var currentLocation: CLLocationCoordinate2D?
    var regionRadius: CLLocationDistance = 100

    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "TaskTableViewCell", bundle: nil),
            forCellReuseIdentifier: TaskTableViewCell.reuseID)
        locationHelper.delegate = self
    }

    func fetchTasks(near location: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: location,
                                      radius: regionRadius,
                                      identifier: "Current location \(Date())")
        tasks = delegate?.tasksNear(region: region) ?? []

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.reuseID,
            for: indexPath)
            as? TaskTableViewCell ?? TaskTableViewCell(
                style: .default,
                reuseIdentifier: TaskTableViewCell.reuseID)
        let task = tasks[indexPath.row]
        cell.setUp(self, forTask: task)

        return cell
    }
}


// MARK: - Location Helper Delegate

extension NearbyTasksViewController: LocationHelperDelegate {
    func currentLocationDidChange(to newLocation: CLLocationCoordinate2D) {
        if currentLocation == nil {
            fetchTasks(near: newLocation)
        }
        currentLocation = newLocation
    }
}


// MARK: - TaskViewDelegate

extension NearbyTasksViewController: TaskViewDelegate {
    func taskView(_ taskView: TaskView, didRequestStateSelectorForTask task: Task) {
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

    func taskView(_ taskView: TaskView,
                  willPerformUpdatesforTask task: Task,
                  updates: @escaping () throws -> Void
    ) {
        delegate?.performUpdates(forTask: task, updates: updates)
    }
}
