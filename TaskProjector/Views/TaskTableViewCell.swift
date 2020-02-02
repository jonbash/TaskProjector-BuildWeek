//
//  TaskTableViewCell.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell, TaskView {

    static let reuseID: String = "TaskCell"

    lazy var longTouchGestureRecognizer = UILongPressGestureRecognizer(
        target: self,
        action: #selector(completeButtonLongPressed(_:)))

    @IBOutlet private weak var checkmarkButton: UIButton! {
        didSet {
            checkmarkButton.addGestureRecognizer(longTouchGestureRecognizer)
        }
    }
    @IBOutlet private weak var taskNameLabel: UILabel!

    var task: Task!
    weak var delegate: TaskViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUp(_ delegate: TaskViewDelegate, forTask task: Task) {
        self.task = task
        self.delegate = delegate
        updateViews()
    }

    func updateViews() {
        guard task != nil else { return }

        let image: UIImage = (task.state.image ?? UIImage.checkmark)
        checkmarkButton.setBackgroundImage(image, for: .normal)
        checkmarkButton.tintColor = task.state.color
        taskNameLabel.text = task.name
    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        toggleTaskComplete()
    }

    @objc func completeButtonLongPressed(
        _ sender: UILongPressGestureRecognizer
    ) {
        if sender.state == .began {
            delegate?.taskView(self, didRequestStateSelectorForTask: task)
        }
    }

    func toggleTaskComplete() {
        task.toggleComplete()
        updateViews()
    }
}
