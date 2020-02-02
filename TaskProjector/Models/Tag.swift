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

@objcMembers
class Tag: Object {
    dynamic var name: String = ""
    private(set) dynamic var identifier: String = UUID().uuidString
    var tasks = LinkingObjects(fromType: Task.self, property: "tags")

    dynamic var parent: Tag?
    var childTags = LinkingObjects(fromType: Tag.self, property: "parent")
    
    private var latitude = RealmOptional<Double>()
    private var longitude = RealmOptional<Double>()

    var location: CLLocationCoordinate2D? {
        get {
            guard let latitude = latitude.value,
                let longitude = longitude.value
                else { return nil }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude.value = newValue?.latitude
            longitude.value = newValue?.latitude
        }
    }

    convenience init(name: String = "", identifier: String = UUID().uuidString) {
        self.init()
        self.name = name
        self.identifier = identifier
    }
}
