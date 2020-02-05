//
//  CategoryPickerView.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-04.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit


class CategoryPickerView: UIPickerView {

    var categoryType: CategoryType = .none {
        didSet {
            DispatchQueue.main.async {
                self.setUp()
            }
        }
    }

    weak var categoryDataSource: CategoryPickerDataSource?

    override var dataSource: UIPickerViewDataSource? {
        get { categoryDataSource }
        set { categoryDataSource = newValue as? CategoryPickerDataSource }
    }

    var selectedCategory: Category? {
        get {
            categoryDataSource?.pickerView(
                self,
                categoryOfType: categoryType,
                forSelectedRow: selectedRow(inComponent: 0))
        }
        set {
            guard
                let newCategory = newValue,
                let newIndex = categoryDataSource?.pickerView(
                    self,
                    rowForSelectedCategory: newCategory)
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
        if categoryType == .none {
            isHidden = true
        } else {
            isHidden = false
            reloadAllComponents()
        }
    }
}
