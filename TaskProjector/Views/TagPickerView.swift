//
//  TagPickerView.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

protocol TagPickerViewDataSource: AnyObject {
    func tagPickerView(_ tagPickerView: TagPickerView, tagForSelectedRow row: Int) -> Tag?
}

class TagPickerView: UIPickerView {

    weak var tagDataSource: TagPickerViewDataSource?

    var selectedTag: Tag? {
        tagDataSource?.tagPickerView(self, tagForSelectedRow: selectedRow(inComponent: 0))
    }

    // MARK: - Init / Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {

    }
}
