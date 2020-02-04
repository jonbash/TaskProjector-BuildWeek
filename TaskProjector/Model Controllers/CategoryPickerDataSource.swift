//
//  CategoryPickerDataSource.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class CategoryPickerDataSource: NSObject {
    weak var taskController: TaskController?

    init(taskController: TaskController) {
        self.taskController = taskController
    }

    func pickerView(
        _ pickerView: CategoryPickerView,
        categoryOfType type: CategoryType,
        forSelectedRow row: Int
    ) -> Category? {
        switch type {
        case .area:
            return taskController?.allAreas?[row]
        case .project:
            return taskController?.allProjects?[row]
        default:
            return nil
        }
    }
}

extension CategoryPickerDataSource: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        guard let pickerView = pickerView as? CategoryPickerView else { return 0 }

        switch pickerView.categoryType {
        case .area: return (taskController?.allAreas?.count ?? 0)
        case .project: return (taskController?.allProjects?.count ?? 0)
        default: return 0
        }
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        guard let pickerView = pickerView as? CategoryPickerView else {
            return nil
        }
        switch pickerView.categoryType {
        case .area:
            return taskController?.allAreas?[row].name ?? "?"
        case .project:
            return taskController?.allProjects?[row].name ?? "?"
        default: return "?"
        }
    }
}
