//
//  TaskCategoryViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TaskCategoryViewController: AddTaskViewController {

    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var categoryPicker: CategoryPickerView!

    var category: Category? {
        get {
            categoryPicker.selectedCategory
        }
        set {
            let categoryType: CategoryType = {
                if newValue as? Area != nil {
                    return .area
                } else if newValue as? Task != nil {
                    return .project
                } else {
                    return .none
                }
            }()
            categorySegmentedControl.selectedSegmentIndex = categoryType.rawValue

            categoryPicker.selectedCategory = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = taskCreationClient?.categoryPickerDataSource
        categoryPicker.delegate = taskCreationClient?.categoryPickerDataSource

        category = taskCreationClient?.task.parent
    }

    @IBAction private func addCategoryButtonTapped(_ sender: UIButton) {
        if let type = CategoryType(
            rawValue: categorySegmentedControl.selectedSegmentIndex + 1) {
            taskCreationClient?.taskCreator(self, didRequestNewCategory: type)
        }
    }

    @IBAction private func categoryChanged(_ sender: Any) {
        let typeIndex = categorySegmentedControl.selectedSegmentIndex
        categoryPicker.categoryType = CategoryType(rawValue: typeIndex) ?? .none
        category = categoryPicker.selectedCategory
    }
}
