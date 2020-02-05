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
        taskController?.allTags?[row]
    }

    func tagPickerView(_ tagPickerView: TagPickerView, indexForTag tag: Tag) -> Int? {
        taskController?.allTags?.index(of: tag)
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
        taskController?.allTags?[row].name ?? "?"
    }
}
