//
//  TaskDueDateViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskDueDateViewController: AddTaskViewController {

    @IBOutlet private weak var dueDateSwitch: UISwitch!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!

    private(set) var dueDate: Date? {
        get { (dueDateSwitch.isOn) ? dueDatePicker.date : nil }
        set {
            let hasDueDate = (newValue != nil)
            dueDateSwitch.setOn(hasDueDate, animated: true)
            dueDatePicker.isHidden = !hasDueDate
            dueDatePicker.setDate(newValue ?? Date(), animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dueDate = taskCreationClient?.task.dueDate
    }

    @IBAction private func dueDateChanged(_ sender: Any) {
        let hasDueDate = dueDateSwitch.isOn
        dueDatePicker.isHidden = !hasDueDate
    }
}
