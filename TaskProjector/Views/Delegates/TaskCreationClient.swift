//
//  TaskCreationProvider.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

@objc
protocol TaskCreationClient: AnyObject {
    func didRequestTaskCreation()
}
