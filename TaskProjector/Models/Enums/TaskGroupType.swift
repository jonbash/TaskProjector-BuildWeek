//
//  TaskGroupType.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import RealmSwift

@objc
enum TaskGroupType: Int, RealmEnum {
    case sequential
    case parallel
}
