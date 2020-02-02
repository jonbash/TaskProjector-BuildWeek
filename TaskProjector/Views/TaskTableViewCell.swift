//
//  TaskTableViewCell.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    static let reuseID: String = "TaskCell"

    let longTouchGestureRecognizer = UILongPressGestureRecognizer(
        target: self,
        action: #selector(completeButtonLongPressed(_:)))

    @IBOutlet private weak var checkmarkButton: UIButton! {
        didSet {
            checkmarkButton.addGestureRecognizer(longTouchGestureRecognizer)
        }
    }
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
        guard task != nil else { return }

        let image: UIImage = (task.state.image ?? UIImage.checkmark)
        checkmarkButton.setBackgroundImage(image, for: .normal)
        checkmarkButton.tintColor = task.state.color
        taskNameLabel.text = task.name
    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        task.toggleComplete()
        updateViews()
    }

    @objc func completeButtonLongPressed(
        _ sender: UILongPressGestureRecognizer
    ) {
        print("long press")
    }
}
