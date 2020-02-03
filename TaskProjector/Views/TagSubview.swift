//
//  TagSubview.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TagSubview: UIView {

    var taskTag: Tag! {
        didSet {
            guard taskTag != nil else { return }
            label.text = taskTag.name
        }
    }
    private var label = UILabel()
    private var constraintConstant: CGFloat = 4

    convenience init(tag: Tag) {
        self.init()
        self.taskTag = tag
        setUp()
    }

    private func setUp() {
        label.text = taskTag.name
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: constraintConstant),
            label.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -constraintConstant),
            label.topAnchor.constraint(equalTo: topAnchor,
                                       constant: constraintConstant),
            label.bottomAnchor.constraint(equalTo: bottomAnchor,
                                          constant: -constraintConstant)])
        backgroundColor = .quaternarySystemFill
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        layer.masksToBounds = true
        layer.cornerRadius = 2
    }

}
