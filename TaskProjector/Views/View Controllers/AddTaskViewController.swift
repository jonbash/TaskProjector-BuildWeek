//
//  AddTaskViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class AddTaskViewController: ShiftableViewController {
    enum ViewState: Int {
        case title
        case category
        case timeEstimate
        case dueDate
        case all
    }

    var currentViewState: ViewState = .title

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

    private var prevButton: UIBarButtonItem!
    private var nextButton: UIBarButtonItem!
    private var saveButton: UIBarButtonItem!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    // MARK: - Actions

    @IBAction private func addCategoryButtonTapped(_ sender: UIButton) {

    }

    @objc private func prevButtonTapped(_ sender: Any) {
        changeViewState(forward: false)
    }

    @objc private func nextButtonTapped(_ sender: Any) {
        changeViewState(forward: true)
    }

    @objc private func saveButtonTapped(_ sender: Any) {

    }

    // MARK: - View Setup/Update

    func setUp() {
        title = "New task"
        prevButton = UIBarButtonItem(title: "< Prev",
                                     style: .plain,
                                     target: self,
                                     action: #selector(prevButtonTapped(_:)))
        prevButton.isEnabled = false
        nextButton = UIBarButtonItem(title: "Next >",
                                     style: .plain,
                                     target: self,
                                     action: #selector(nextButtonTapped(_:)))
        nextButton.isEnabled = false
        saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                     target: self,
                                     action: #selector(saveButtonTapped(_:)))
        saveButton.isEnabled = false
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: nil,
                                     action: nil)
        toolbarItems = [prevButton, spacer, saveButton, spacer, nextButton]

        titleField.delegate = self

        categoryStackView.isHidden = true
        timeEstimateStackView.isHidden = true
        dueDateStackView.isHidden = true
        scrollView.contentSize.width = view.bounds.width
    }

    private func changeViewState(forward: Bool) {
        currentViewState = ViewState(rawValue:
            currentViewState.rawValue + (forward ? 1 : -1))
            ?? currentViewState
        updateViewsForState()
    }

    private func updateViewsForState() {
        prevButton.isEnabled = (currentViewState != .title)
        saveButton.isEnabled = (currentViewState != .title ||
            (titleField.text != nil && !titleField.text!.isEmpty))
        if currentViewState == .all {
            titleStackView.isHidden = false
            categoryStackView.isHidden = false
            timeEstimateStackView.isHidden = false
            dueDateStackView.isHidden = false
            nextButton.isEnabled = false
        } else {
            titleStackView.isHidden = (currentViewState != .title)
            categoryStackView.isHidden = (currentViewState != .category)
            timeEstimateStackView.isHidden = (currentViewState != .timeEstimate)
            dueDateStackView.isHidden = (currentViewState != .dueDate)
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
                nextButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
                nextButton.isEnabled = false
            }
        }
    }
}
