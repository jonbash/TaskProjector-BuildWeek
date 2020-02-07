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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tagsCoordinator?.tagCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        let tag = tagsCoordinator?.tag(forIndexPath: indexPath)

        cell.textLabel?.text = tag?.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tagsCoordinator?.viewTagDetails(forIndex: indexPath)
    }
}
