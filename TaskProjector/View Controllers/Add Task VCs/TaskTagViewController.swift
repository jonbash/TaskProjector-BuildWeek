//
//  TaskTagViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskTagViewController: AddTaskViewController {

    @IBOutlet private weak var tagPicker: TagPickerView!
    @IBOutlet private weak var tagSwitch: UISwitch!

    var tag: Tag? {
        get { tagSwitch.isOn ? tagPicker.selectedTag : nil }
        set {
            tagSwitch.isOn = (newValue != nil)
            tagPicker.selectedTag = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tagPicker.tagDataSource = taskCreationClient?.tagPickerDataSource
        tagPicker.delegate = taskCreationClient?.tagPickerDataSource
    }

    @IBAction private func tagChanged(_ sender: Any) {
        let hasTag = tagSwitch.isOn
        tagPicker.isHidden = !hasTag
    }
}
