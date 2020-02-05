//
//  TagPickerView.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit

class TagPickerView: UIPickerView {

    weak var tagDataSource: TagPickerDataSource?

    override var dataSource: UIPickerViewDataSource? {
        get { tagDataSource }
        set { tagDataSource = newValue as? TagPickerDataSource }
    }

    var selectedTag: Tag? {
        get {
            tagDataSource?.tagPickerView(
                self,
                tagForSelectedRow: selectedRow(inComponent: 0))
        }
        set {
            guard
                let newTag = newValue,
                let newIndex = tagDataSource?.tagPickerView(self, indexForTag: newTag)
                else { return }
            self.selectRow(newIndex, inComponent: 0, animated: true)
        }
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
