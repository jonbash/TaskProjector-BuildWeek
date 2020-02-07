//
//  UIAlert+Convenience.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-01.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

extension UIAlertAction {
    static let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    static let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
}

extension UIAlertController {
    static func informationalAlert(withTitle title: String, text: String) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: text,
            preferredStyle: .alert)
        alert.addAction(.okay)
        return alert
    }
}

extension UIViewController {
    func presentInformationalAlert(withTitle title: String, text: String) {
        present(UIAlertController.informationalAlert(withTitle: title, text: text),
                animated: true,
                completion: nil)
    }
}
