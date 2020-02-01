//
//  Area.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

class Area: Object, Category {
    var name: String = ""
    var identifier: String = UUID().uuidString
    var children: [Completable] = []
}
