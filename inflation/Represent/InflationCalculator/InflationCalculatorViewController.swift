//
//  InflationCalculatorViewController.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 14/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import UIKit

final class InflationCalculatorViewController: UIViewController {
    
    var presenter: InflationCalculatorPresenter!
    
    var startYearAdapter: InflationCalculatorPickerViewAdapterInput!
    var endYearAdapter: InflationCalculatorPickerViewAdapterInput!
    var startMonthAdapter: InflationCalculatorPickerViewAdapterInput!
    var endMonthAdapter: InflationCalculatorPickerViewAdapterInput!

    
    //MARK: Outlets
    @IBOutlet weak var startYearPickerView: UIPickerView!
    @IBOutlet weak var endYearPickerView: UIPickerView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var startMonthPickerView: UIPickerView!
    @IBOutlet weak var endMonthPickerView: UIPickerView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var inflationLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.inflationCalculatorTitle()
        startYearAdapter.set(pickerView: startYearPickerView)
        endYearAdapter.set(pickerView: endYearPickerView)
        startMonthAdapter.set(pickerView: startMonthPickerView)
        endMonthAdapter.set(pickerView: endMonthPickerView)
        presenter.didLoad()
    }
    
    @IBAction func repeatButtonDidTapped(_ sender: Any) {
        presenter.didPressedRepeatButton()
    }

}

//MARK: InflationCalculatorPickerViewAdapterOutput

extension InflationCalculatorViewController: InflationCalculatorPickerViewAdapterOutput {
    func didSelect(index: Int, in type: InflationCalculatorPickerViewAdapterType) {
        presenter.didUpdateSelectedItem(newIndex: index, type: type)
    }
}

extension InflationCalculatorViewController: InflationCalculatorPresenterOutput {
    func set(endYearIndex: Int) {
        endYearAdapter.set(index: endYearIndex)
    }
    
    func set(endMonthIndex: Int) {
        endMonthAdapter.set(index: endMonthIndex)
    }
    
    func set(startYears: [String]) {
        startYearAdapter.set(data: startYears)
    }
    
    func set(endYears: [String]) {
        endYearAdapter.set(data: endYears)
    }
    
    func set(startMonths: [String]) {
        startMonthAdapter.set(data: startMonths)
    }
    
    func set(endMonths: [String]) {
        endMonthAdapter.set(data: endMonths)
    }
    
    func set(inflationData: InflationCalculatedData?) {
        if let inflationData = inflationData {
            inflationLabel.text = R.string.localizable.inflationCalculatorCalculationInfoFormat(R.string.localizable.inflationCalculatorMonthsCount(variablE: inflationData.monthsCount), Double(inflationData.value)) //конструктор почему-то просит Double
        } else {
            inflationLabel.text = nil
        }
    }
    
    func show(error: String) {
        self.errorView.isHidden = false
        self.errorLabel.text = error
    }
    
    func showLoader() {
        self.loadingView.isHidden = false
    }
    
    func dismissLoader() {
        self.loadingView.isHidden = true
    }
    
    func dismissError() {
        self.errorView.isHidden = true
    }
    
    
}
