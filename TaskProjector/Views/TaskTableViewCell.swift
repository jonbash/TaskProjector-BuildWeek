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

    var task: Task!
    weak var delegate: TaskViewDelegate?

    lazy var checkboxLongPress = UILongPressGestureRecognizer(
        target: self,
        action: #selector(completeButtonLongPressed(_:)))

    // MARK: - SubViews

    @IBOutlet private weak var taskNameLabel: UILabel!
    @IBOutlet private weak var checkmarkButton: UIButton! {
        didSet {
            checkmarkButton.addGestureRecognizer(checkboxLongPress)
        }
    }
    @IBOutlet private weak var tagsStackView: UIStackView!

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func toggleTaskComplete() {
        delegate?.taskView(self, willPerformUpdatesforTask: task, updates: {
            self.task.toggleComplete()
        })
        updateViews()
    }

    // MARK: - Actions

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

    // MARK: - Setup/Update

    func setUp(_ delegate: TaskViewDelegate, forTask task: Task) {
        self.task = task
        self.delegate = delegate
        updateViews()

        tagsStackView.isHidden = task.tags.isEmpty
        tagsStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }

        for tag in task.tags {
            let tagView = TagSubview(tag: tag)
            tagsStackView.addArrangedSubview(tagView)
        }
    }

    func updateViews() {
        guard task != nil else { return }

        let image: UIImage = (task.state.image ?? UIImage.checkmark)
        checkmarkButton.setBackgroundImage(image, for: .normal)
        checkmarkButton.tintColor = task.state.color
        taskNameLabel.text = task.name
        if let dueStateColor = task.dueState.color {
            backgroundColor = dueStateColor
        } else {
            backgroundColor = .systemBackground
        }
    }
}
