//
//  CategoryPickerView.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


class CategoryPickerView: UIPickerView {

    var categoryType: CategoryType = .area {
        didSet {
            DispatchQueue.main.async {
                self.setUp()
            }
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
        isHidden = (categoryType == .none)
        reloadAllComponents()
    }
}
