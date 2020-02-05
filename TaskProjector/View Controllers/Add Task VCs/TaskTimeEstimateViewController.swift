//
//  TaskTimeEstimateViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskTimeEstimateViewController: AddTaskViewController {

    @IBOutlet private weak var timeEstimatePicker: UIDatePicker!
    @IBOutlet private weak var timeEstimateSwitch: UISwitch!

    var timeEstimate: TimeInterval? {
        get { (timeEstimateSwitch.isOn) ? timeEstimatePicker.countDownDuration : nil }
        set {
            if let newEstimate = newValue {
                timeEstimatePicker.countDownDuration = newEstimate
                timeEstimateSwitch.isOn = true
            } else {
                timeEstimateSwitch.isOn = false
            }
            timeEstimatePicker.isHidden = !timeEstimateSwitch.isOn
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        timeEstimate = taskCreationClient?.task.timeEstimate
    }

    @IBAction private func timeEstimateChanged(_ sender: Any) {
        timeEstimatePicker.isHidden = !timeEstimateSwitch.isOn
    }
}
