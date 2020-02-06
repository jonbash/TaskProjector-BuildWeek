//
//  Tag+MapAnnotation.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-06.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import MapKit

extension Tag {
    var mapAnnotation: TagMapAnnotation? {
        guard location != nil else { return nil }
        return TagMapAnnotation(tag: self)
    }
}

class TagMapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    let tagIdentifier: String

    init?(tag: Tag) {
        guard tag.location != nil else { return nil }
        
        self.tagIdentifier = tag.identifier
        self.title = tag.name
        self.coordinate = tag.location!
    }
}
