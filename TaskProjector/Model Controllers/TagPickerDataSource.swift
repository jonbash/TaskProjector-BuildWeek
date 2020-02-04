//
//  TagPickerDataSource.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TagPickerDataSource: NSObject {
    weak var taskController: TaskController?

    init(taskController: TaskController) {
        self.taskController = taskController
    }

    func tagPickerView(_ tagPickerView: TagPickerView, tagForSelectedRow row: Int) -> Tag? {
        taskController?.allTags?[row - 1]
    }
}

extension TagPickerDataSource: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        taskController?.allTags?.count ?? 0
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        if row == 0 {
            return .kNone
        } else {
            return taskController?.allTags?[row - 1].name ?? "?"
        }
    }
}
