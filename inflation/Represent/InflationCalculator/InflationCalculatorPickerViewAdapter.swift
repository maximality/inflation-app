//
//  InflationCalculatorPickerViewAdapter.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 14/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import UIKit

enum InflationCalculatorPickerViewAdapterType {
    case startYear
    case endYear
    case startMonth
    case endMonth
}

protocol InflationCalculatorPickerViewAdapterInput: class {
    func set(data: [String])
    func set(pickerView: UIPickerView)
    func set(index: Int)
}

protocol InflationCalculatorPickerViewAdapterOutput: class {
    func didSelect(index: Int, in type: InflationCalculatorPickerViewAdapterType)
}

final class InflationCalculatorPickerViewAdapter: NSObject {
    
    private let type: InflationCalculatorPickerViewAdapterType
    private weak var output: InflationCalculatorPickerViewAdapterOutput?
    
    //MARK: Properties
    fileprivate var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    fileprivate var data: [String]? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    //MARK: Init
    init(output: InflationCalculatorPickerViewAdapterOutput, type: InflationCalculatorPickerViewAdapterType) {
        self.output = output
        self.type = type
        super.init()
    }
}

//MARK: UIPickerViewDelegate&DataSource

extension InflationCalculatorPickerViewAdapter: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        output?.didSelect(index: row, in: type)
    }
}

//MARK: Input

extension InflationCalculatorPickerViewAdapter: InflationCalculatorPickerViewAdapterInput {
    func set(index: Int) {
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func set(data: [String]) {
        self.data = data
    }
    
    func set(pickerView: UIPickerView) {
        self.pickerView = pickerView
    }
}
