//
//  AddTaskViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


class AddTaskViewController: ShiftableViewController {
    private(set) var taskAttribute: NewTaskAttribute = .title

    weak var taskCreationClient: TaskCreationClient?

    // MARK: - SubViews

    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var categoryStackView: UIStackView!
    @IBOutlet private weak var timeEstimateStackView: UIStackView!
    @IBOutlet private weak var dueDateStackView: UIStackView!

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var categoryPicker: UIPickerView!
    @IBOutlet private weak var timeEstimatePicker: UIDatePicker!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!

    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var timeEstimateSwitch: UISwitch!
    @IBOutlet private weak var dueDateSwitch: UISwitch!

    @IBOutlet private weak var scrollView: UIScrollView!

    private var nextButton: UIBarButtonItem?
    private var saveButton: UIBarButtonItem!

    // MARK: - Init / View Lifecycle

    convenience init(state: NewTaskAttribute, client: TaskCreationClient) {
        self.init()
        self.taskAttribute = state
        self.taskCreationClient = client
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskAttribute.viewTitleForNewTaskState()
        setUpBarButtons()
        showHideStackViews()

        titleField.delegate = self

        scrollView.contentSize.width = view.bounds.width
    }

    // MARK: - Actions

    @IBAction private func addCategoryButtonTapped(_ sender: UIButton) {
        if let type = CategoryType(rawValue: categorySegmentedControl.selectedSegmentIndex + 1) {
            taskCreationClient?.taskCreator(self, didRequestNewCategory: type)
        }
    }

    @objc private func nextButtonTapped(_ sender: Any) {
        finalizeAndProceed()
    }

    @objc private func saveButtonTapped(_ sender: Any) {
        taskCreationClient?.taskCreatorDidRequestTaskSave(self)
    }

    @objc private func cancelButtonTapped(_ sender: Any) {
        taskCreationClient?.taskCreatorDidCancel(self)
    }

    // MARK: - TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField { textField.resignFirstResponder() }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            if let title = textField.text, !title.isEmpty {
                finalizeAndProceed()
            } else {
                saveButton.isEnabled = false
                nextButton?.isEnabled = false
            }
        }
    }

    // MARK: - Helper Methods

    private func finalizeAndProceed() {
        var value: Any?
        switch taskAttribute {
        case .title: value = titleField.text
        case .category:
            // TODO: set categorypicker value to actual category
            value = categoryPicker.selectedRow(inComponent: 0)
        case .timeEstimate: value = timeEstimatePicker.countDownDuration
        case .dueDate: value = dueDatePicker.date
        default: break
        }
        taskCreationClient?.taskCreator(self,
                                        didSetValue: value,
                                        forAttribute: taskAttribute)
        taskCreationClient?.taskCreatorDidRequestNextState(self)
    }

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
        saveButton.isEnabled = taskAttribute != .title
        toolbarItems = [cancelButton, spacer, saveButton, spacer]
        if taskAttribute != .all {
            nextButton = UIBarButtonItem(
                title: "Next >",
                style: .plain,
                target: self,
                action: #selector(nextButtonTapped(_:)))
            nextButton!.isEnabled = (taskAttribute != .title)
            toolbarItems?.append(nextButton!)
        }
    }

    private func showHideStackViews() {
        if taskAttribute == .all {
            titleStackView.isHidden = false
            categoryStackView.isHidden = false
            timeEstimateStackView.isHidden = false
            dueDateStackView.isHidden = false
            nextButton?.isEnabled = false
        } else {
            titleStackView.isHidden = (taskAttribute != .title)
            categoryStackView.isHidden = (taskAttribute != .category)
            timeEstimateStackView.isHidden = (taskAttribute != .timeEstimate)
            dueDateStackView.isHidden = (taskAttribute != .dueDate)
        }
    }
}
