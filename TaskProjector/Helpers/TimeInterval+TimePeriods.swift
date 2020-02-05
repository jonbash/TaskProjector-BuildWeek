//
//  TimeInterval+TimePeriods.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

extension TimeInterval {
    var minutes: Double { self / 60 }
    var hours: Double { self / 3600 }
    var days: Double { self / 86_400 }
    var weeks: Double { self / 604_800 }
    // TODO: improve months and years calculation
    /// as 30.41666666... days
    var months: Double { self / 2_628_000 }
    /// as 365 days
    var years: Double { self / 31_536_000 }

    var absoluteValue: TimeInterval { (self > 0) ? self : -self }

    init(minutes: Double) { self = minutes * 60 }
    init(hours: Double) { self = hours * 3600 }
    init(days: Double) { self = days * 86_400 }
    init(weeks: Double) { self = weeks * 604_800 }
    init(months: Double) { self = months * 2_628_000 }
    init(years: Double) { self = years * 31_536_000 }
}
