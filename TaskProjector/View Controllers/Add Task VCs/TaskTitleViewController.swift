//
//  TaskTitleViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskTitleViewController: AddTaskViewController {

    @IBOutlet private weak var titleField: UITextField!

    var taskTitle: String {
        get { titleField.text ?? "" }
        set { titleField.text = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        
        if let taskTitle = creationClient?.task.name, !taskTitle.isEmpty {
            title = taskTitle
            titleField.text = taskTitle
        } else {
            title = "New Task"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let editing = editingClient?.amEditing, editing {
            editingClient?.finishEditing(self)
        }
    }

    // MARK: - TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField { textField.resignFirstResponder() }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            if let title = textField.text, !title.isEmpty {
                saveButton.isEnabled = true
                nextButton?.isEnabled = true
            } else {
                saveButton.isEnabled = false
                nextButton?.isEnabled = false
            }
        }
    }
}
