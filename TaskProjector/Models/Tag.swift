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
    @objc dynamic var name: String = ""
    @objc private(set) dynamic var identifier: String = UUID().uuidString
    var tasks = List<Task>()
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
