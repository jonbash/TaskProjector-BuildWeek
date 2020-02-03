//
//  TaskCreationClient.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation


protocol TaskCreationClient: AnyObject {
    func taskCreator(_ sender: Any, didRequestNextState: Bool)
    func taskCreatorDidRequestTaskSave(_ sender: Any)
    func taskCreator(_ sender: Any, didRequestNewCategory: CategoryType)
}
