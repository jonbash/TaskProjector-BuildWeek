//
//  UIViewController+Convenience.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-01-31.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}
