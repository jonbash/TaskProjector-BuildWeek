//
//  TaskTableViewCell.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet private weak var checkmarkButton: UIButton!
    @IBOutlet private weak var taskNameLabel: UILabel!

    var task: Task!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateViews() {
        checkmarkButton.setBackgroundImage(task.state.image, for: .normal)
        taskNameLabel.text = task.name
    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        task.toggleComplete()
        updateViews()
    }

    @IBAction func completeButtonLongPressed(
        _ sender: UILongPressGestureRecognizer
    ) {
        print("long press")
    }
}
