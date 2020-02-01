//
//  Tag.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Tag: Object {
    var name: String = ""
    var identifier: String = UUID().uuidString
    var children: [Completable] = []
    var location: CLLocationCoordinate2D?
}
