//
//  UIViewController+InitFromSB.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-06.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardInitializable {
    static func initFromStoryboard(withName storyboardName: String) -> Self? {
        UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(
            withIdentifier: String(describing: Self.self))
            as? Self
    }
}
