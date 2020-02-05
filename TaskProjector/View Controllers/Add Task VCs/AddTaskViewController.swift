//
//  AddTaskViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


class AddTaskViewController: ShiftableViewController {
    weak var taskCreationClient: TaskCreationClient?

    var nextButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem!

    // MARK: - Init / View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButtons()
    }

    // MARK: - Actions

    /// Default method calls `taskCreationClient?.requestNextCreationStep(self)`
    @objc func nextButtonTapped(_ sender: Any) {
        taskCreationClient?.requestNextCreationStep(self)
    }

    /// Default method calls `taskCreationClient?.requestTaskSave(self)`
    @objc func saveButtonTapped(_ sender: Any) {
        taskCreationClient?.requestTaskSave(self)
    }

    /// Default method calls `taskCreationClient?.cancelTaskCreation(self)`
    @objc func cancelButtonTapped(_ sender: Any) {
        taskCreationClient?.cancelTaskCreation(self)
    }

    // MARK: Setup

    private func setUpBarButtons() {
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped(_:)))
        toolbarItems?.append(cancelButton)
        saveButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped(_:)))
        toolbarItems = [cancelButton, spacer, saveButton, spacer]
        nextButton = UIBarButtonItem(
            title: "Next >",
            style: .plain,
            target: self,
            action: #selector(nextButtonTapped(_:)))
        toolbarItems?.append(nextButton!)
        nextButton?.isEnabled = !(taskCreationClient?.amEditing ?? true)
    }
}
