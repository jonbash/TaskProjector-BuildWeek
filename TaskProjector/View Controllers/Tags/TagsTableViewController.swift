//
//  TagsTableViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


// MARK: - FILE CURRENTLY NOT IN TARGET

class TagsTableViewController: UITableViewController {

    weak var tagsCoordinator: TagsCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tags"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Tableview Methods

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        tagsCoordinator?.tagCount ?? 0
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell",
                                                 for: indexPath)
        let tag = tagsCoordinator?.tag(forIndexPath: indexPath)

        cell.textLabel?.text = tag?.name

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tagsCoordinator?.viewTagDetails(forIndex: indexPath)
    }
}
