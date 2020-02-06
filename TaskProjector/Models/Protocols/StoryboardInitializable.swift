//
//  StoryboardInitializable.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-06.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol StoryboardInitializable {
    static func initFromStoryboard(withName storyboardName: String) -> Self?
}
