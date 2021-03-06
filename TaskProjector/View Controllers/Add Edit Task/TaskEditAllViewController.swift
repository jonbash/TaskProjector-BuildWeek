//
//  AddTaskViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


class TaskEditAllViewController: AddTaskViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var timeEstimateLabel: UILabel!
    @IBOutlet private weak var dueDateLabel: UILabel!

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton?.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let task = creationClient?.task else { return }

        titleLabel.text = task.name
        categoryLabel.text = task.parent?.name ?? .kNone
        tagLabel.text = task.tags.first?.name ?? .kNone
        timeEstimateLabel.text = {
            if let time = task.timeEstimate {
                var minutes = Int(time / 60)
                let hours = minutes / 60
                minutes -= hours * 60
                return "\(hours)h \(minutes)m"
            } else { return .kNone }
        }()
        dueDateLabel.text = {
            if let date = task.dueDate {
                return dateFormatter.string(from: date)
            } else { return .kNone }
        }()
    }

    // MARK: - Actions

    @IBAction private func titleLabelTapped(_ sender: Any) {
        editingClient?.editTask(attribute: .title)
    }

    @IBAction private func categoryLabelTapped(_ sender: Any) {
        editingClient?.editTask(attribute: .category)
    }

    @IBAction private func tagLabelTapped(_ sender: Any) {
        editingClient?.editTask(attribute: .tag)
    }

    @IBAction private func timeEstimateLabelTapped(_ sender: Any) {
        editingClient?.editTask(attribute: .timeEstimate)
    }

    @IBAction private func dueDateLabelTapped(_ sender: Any) {
        editingClient?.editTask(attribute: .dueDate)
    }
}
