//
//  TaskCreationClient.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation


@objc
protocol TaskCreationClient: AnyObject {
    func taskCreatorDidRequestNextState(_ sender: Any)
    func taskCreatorDidRequestPrevState(_ sender: Any)
    func taskCreatorDidRequestTaskSave(_ sender: Any)
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType)
    func taskCreatorDidCancel(_ sender: Any)
    func taskCreator(_ sender: Any,
                     didSetValue value: Any?,
                     forAttribute attribute: NewTaskAttribute)
}
