//
//  AddTaskCoordinator.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-03.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class AddTaskCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var addTaskVCs = [NewTaskAttribute: AddTaskViewController]()

    var taskController: TaskController
    var task = Task()

    // MARK: - Init / Start

    init(navigationController: UINavigationController,
         taskController: TaskController
    ) {
        self.navigationController = navigationController
        self.taskController = taskController
    }

    func start() {
        task = Task()
        addViewController(forState: .title)
    }

    // MARK: - Helper Methods

    private func addViewController(forState state: NewTaskAttribute) {
        let newVC = AddTaskViewController(state: state, client: self)
        addTaskVCs[state] = newVC

        navigationController.pushViewController(newVC, animated: true)
    }

    private func updateTask(updates: @escaping () -> Void) {
        do {
            try taskController.performUpdates(updates)
        } catch {
            NSLog("Error performing updates on task: \(error)")
        }
    }
}

// MARK: - Task Creation Client

extension AddTaskCoordinator: TaskCreationClient {
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType) {
        // TODO: implement this method
    }

    func taskCreatorDidRequestNextState(_ sender: Any) {
        guard let addVC = sender as? AddTaskViewController,
            let newState = NewTaskAttribute(rawValue: addVC.taskAttribute.rawValue + 1)
            else { return }
        addViewController(forState: newState)
    }

    @objc func taskCreatorDidRequestPrevState(_ sender: Any) {
        navigationController.popViewController(animated: true)
    }

    func taskCreatorDidCancel(_ sender: Any) {
        navigationController.popToRootViewController(animated: true)
    }

    // MARK: - Task Building

    func taskCreator(
        _ sender: Any,
        didSetValue value: Any?,
        forAttribute attribute: NewTaskAttribute
    ) {
        updateTask { [weak self] in
            switch attribute {
            case .title:
                self?.task.name = value as? String ?? ""
            case .category:
                self?.task.parent = value as? Category
            case .timeEstimate:
                self?.task.timeEstimate = value as? TimeInterval
            case .dueDate:
                self?.task.dueDate = value as? Date
            case .tag:
                if let tag = value as? Tag {
                    self?.task.tagsAsArray = [tag]
                } else { self?.task.tagsAsArray = [] }
            case .all: break
            }
        }
    }

    func taskCreatorDidRequestTaskSave(_ sender: Any) {
        do {
            try taskController.saveTask(task)
        } catch {
            NSLog("Error saving task \(task): \(error)")
        }
        navigationController.popToRootViewController(animated: true)
    }
}

extension AddTaskCoordinator: UIPickerViewDelegate {

}

// MARK: - PickerView DataSource

extension AddTaskCoordinator: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        if let pickerView = pickerView as? CategoryPickerView {
            return categoryPickerView(pickerView,
                                      numberOfRowsInComponent: component)
        } else if let pickerView = pickerView as? TagPickerView {
            return tagPickerView(pickerView,
                                 numberOfRowsInComponent: component)
        }
        return 0
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        if let pickerView = pickerView as? CategoryPickerView {
            return categoryPickerView(pickerView,
                                      titleForRow: row,
                                      forComponent: component)
        } else if let pickerView = pickerView as? TagPickerView {
            return tagPickerView(pickerView,
                                 titleForRow: row,
                                 forComponent: component)
        }
        return nil
    }

    // MARK: Category Picker

    private func categoryPickerView(
        _ pickerView: CategoryPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        switch pickerView.categoryType {
        case .area: return (taskController.allAreas?.count ?? 0) + 1
        case .project: return (taskController.allProjects?.count ?? 0) + 1
        }
    }

    private func categoryPickerView(
        _ pickerView: CategoryPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        if row == 0 {
            return .kNone
        } else {
            switch pickerView.categoryType {
            case .area:
                return taskController.allAreas?[row - 1].name ?? "?"
            case .project:
                return taskController.allProjects?[row - 1].name ?? "?"
            }
        }
    }
}

// MARK: Tag Picker

extension AddTaskCoordinator: TagPickerViewDataSource {
    func tagPickerView(_ tagPickerView: TagPickerView, tagForSelectedRow row: Int) -> Tag? {
        taskController.allTags?[row - 1]
    }

    private func tagPickerView(
        _ pickerView: TagPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        taskController.allTags?.count ?? 0
    }

    private func tagPickerView(
        _ pickerView: TagPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        if row == 0 {
            return .kNone
        } else {
            return taskController.allTags?[row - 1].name ?? "?"
        }
    }
}
