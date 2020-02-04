//
//  AddTaskViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


class AddTaskViewController: ShiftableViewController {
    private(set) var currentViewState: TaskCreationState = .title

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

    convenience init(state: TaskCreationState, client: TaskCreationClient) {
        self.init()
        self.currentViewState = state
        self.taskCreationClient = client
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleForState()
        setUpRightBarButtons()
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
        taskCreationClient?.taskCreatorDidRequestNextState(self)
    }

    @objc private func saveButtonTapped(_ sender: Any) {
        taskCreationClient?.taskCreatorDidRequestTaskSave(self)
    }

    // MARK: - TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField { textField.resignFirstResponder() }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            if let title = textField.text, !title.isEmpty {
                taskCreationClient?.taskCreatorDidRequestNextState(self)
            } else {
                saveButton.isEnabled = false
                nextButton?.isEnabled = false
            }
        }
    }

    // MARK: - Helper Methods

    private func titleForState() -> String {
        let suffix: String
        switch currentViewState {
        case .title:
            suffix = "Title"
        case .category:
            suffix = "Category"
        case .timeEstimate:
            suffix = "Time estimate"
        case .dueDate:
            suffix = "Due date"
        case .all:
            suffix = "Save?"
        }
        return "New task - \(suffix)"
    }

    private func setUpRightBarButtons() {
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: taskCreationClient,
            action: #selector(taskCreationClient?.taskCreatorDidCancel(_:)))
        toolbarItems?.append(cancelButton)
        saveButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped(_:)))
        saveButton.isEnabled = currentViewState != .title
        toolbarItems = [cancelButton, spacer, saveButton, spacer]
        if currentViewState != .all {
            nextButton = UIBarButtonItem(
                title: "Next >",
                style: .plain,
                target: self,
                action: #selector(nextButtonTapped(_:)))
            nextButton!.isEnabled = (currentViewState != .title)
            toolbarItems?.append(nextButton!)
        }
    }

    private func showHideStackViews() {
        if currentViewState == .all {
            titleStackView.isHidden = false
            categoryStackView.isHidden = false
            timeEstimateStackView.isHidden = false
            dueDateStackView.isHidden = false
            nextButton?.isEnabled = false
        } else {
            titleStackView.isHidden = (currentViewState != .title)
            categoryStackView.isHidden = (currentViewState != .category)
            timeEstimateStackView.isHidden = (currentViewState != .timeEstimate)
            dueDateStackView.isHidden = (currentViewState != .dueDate)
        }
    }
}
