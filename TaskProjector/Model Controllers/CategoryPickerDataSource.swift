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
}

extension CategoryPickerDataSource: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        guard let pickerView = pickerView as? CategoryPickerView else { return 0 }

        switch pickerView.categoryType {
        case .area: return (taskController?.allAreas?.count ?? 0) + 1
        case .project: return (taskController?.allProjects?.count ?? 0) + 1
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
        if row == 0 {
            return .kNone
        } else {
            switch pickerView.categoryType {
            case .area:
                return taskController?.allAreas?[row - 1].name ?? "?"
            case .project:
                return taskController?.allProjects?[row - 1].name ?? "?"
            default: return "?"
            }
        }
    }
}
