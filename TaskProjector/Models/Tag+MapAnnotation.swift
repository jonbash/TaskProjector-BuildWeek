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
    var mapAnnotation: MapAnnotation? {
        guard location != nil else { return nil }
        return MapAnnotation(tag: self)
    }

    class MapAnnotation: NSObject, MKAnnotation {
        unowned var tag: Tag

        var title: String? { tag.name }
        var coordinate: CLLocationCoordinate2D { tag.location! }

        init?(tag: Tag) {
            guard tag.location != nil else { return nil }
            self.tag = tag
        }
    }
}
