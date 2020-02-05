//
//  Rescaler.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

struct Rescaler<Type: BinaryFloatingPoint> {
    typealias RescaleDomain = (lowerBound: Type, upperBound: Type)

    var fromDomain: RescaleDomain
    var toDomain: RescaleDomain

    init(from: RescaleDomain, to: RescaleDomain) {
        self.fromDomain = from
        self.toDomain = to
    }

    func interpolate(_ x: Type ) -> Type {
        self.toDomain.lowerBound * (1 - x) + self.toDomain.upperBound * x
    }

    func uninterpolate(_ x: Type) -> Type {
        let b = (self.fromDomain.upperBound - self.fromDomain.lowerBound) != 0
            ? self.fromDomain.upperBound - self.fromDomain.lowerBound
            : 1 / self.fromDomain.upperBound
        return (x - self.fromDomain.lowerBound) / b
    }

    func rescale(_ x: Type ) -> Type {
        interpolate( uninterpolate(x) )
    }
}
