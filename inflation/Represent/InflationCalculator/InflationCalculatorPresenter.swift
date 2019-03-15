//
//  InflationCalculatorPresenter.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 14/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation
import RealmSwift

protocol InflationCalculatorPresenterInput: class {
    func didLoad()
    func didUpdateSelectedItem(newIndex: Int, type: InflationCalculatorPickerViewAdapterType)
    func didPressedRepeatButton()
}

protocol InflationCalculatorPresenterOutput: class {
    func set(startYears: [String])
    func set(endYearIndex: Int)
    func set(endYears: [String])
    func set(startMonths: [String])
    func set(endMonthIndex: Int)
    func set(endMonths: [String])
    func set(inflationData: InflationCalculatedData?)
    func showLoader()
    func dismissLoader()
    func show(error: String)
    func dismissError()
}

struct InflationCalculatedData {
    var monthsCount: Int
    var value: Float
}

final class InflationCalculatorPresenter {
    //MARK: Properties
    
    weak var view: InflationCalculatorPresenterOutput?
    var inflationService: InflationService
    
    private var selectedStartYear: Int?
    private var selectedEndYear: Int?
    private var selectedStartMonthIndex: Int?
    private var selectedEndMonthIndex: Int?
    
    private var startYearsStrings = [String]()
    private var startMonthsString = [String]()
    private var endYearsStrings = [String]()
    private var endMonthsStrings = [String]()
    
    private var inflationCalculatedData: InflationCalculatedData?
    
    private var viewIsReady = false
    
    //MARK: Initializer
    
    init(view: InflationCalculatorPresenterOutput, inflationService: InflationService) {
        self.view = view
        self.inflationService = inflationService
        setUp()
    }
    
    private func setUp() {
        inflationService.outputs.addDelegate(delegate: self)
    }
    
    //MARK: Data update
    
    fileprivate func fetchData() {
        if !inflationService.hasData && viewIsReady {
            view?.dismissError()
            view?.showLoader()
        }
        inflationService.updateData()
    }
    
    fileprivate func updateData() {
        
        startYearsStrings.removeAll()
        endYearsStrings.removeAll()
        startMonthsString.removeAll()
        endMonthsStrings.removeAll()
        
        let data = inflationService.inflationData
        
        if selectedStartYear == nil {
            selectedStartYear = data.first?.year
            selectedStartMonthIndex = data.first?.sortedMonths.first?.orderIndex
            selectedEndYear = selectedStartYear
            selectedEndMonthIndex = selectedStartMonthIndex
        }
        
        for year in data {
            startYearsStrings.append("\(year.year)")
            if let selectedStartYear = selectedStartYear {
                if year.year >= selectedStartYear {
                    endYearsStrings.append("\(year.year)")
                }
            }
        }
        
        guard let firstYear = data.first else {
            return
        }
        
        for month in firstYear.sortedMonths {
            startMonthsString.append(month.name)
            if selectedStartYear == selectedEndYear {
                if let selectedStartMonthIndex = selectedStartMonthIndex {
                    if month.orderIndex >= selectedStartMonthIndex {
                        endMonthsStrings.append(month.name)
                    }
                }
            } else {
                endMonthsStrings.append(month.name)
            }
        }

        
        calculateInflation()
        
        if !viewIsReady {
            return
        }
        
        view?.set(startYears: startYearsStrings)
        view?.set(endYears: endYearsStrings)
        view?.set(startMonths: startMonthsString)
        view?.set(endMonths: endMonthsStrings)
        view?.set(inflationData: inflationCalculatedData)
        
        view?.dismissLoader()
        view?.dismissError()
        
    }
    
    //MARK: Calculation
    
    private func calculateInflation() {
        guard let selectedStartYear = selectedStartYear,
            let selectedEndYear = selectedEndYear,
            let selectedStartMonthIndex = selectedStartMonthIndex,
            let selectedEndMonthIndex = selectedEndMonthIndex else {
                return
        }
        //TODO: Наверное, можно сделать и получше, но что-то не удалось вспомнить матан :)
        let startSum: Float = 100.0
        var processingSum = startSum
        let data = inflationService.inflationData
        var monthsCount = 0
        
        for year in data {
            if year.year < selectedStartYear || year.year > selectedEndYear {
                continue
            }
            let months = year.sortedMonths
            for month in months {
                if (year.year == selectedStartYear && month.orderIndex < selectedStartMonthIndex) ||
                    (year.year == selectedEndYear && month.orderIndex > selectedEndMonthIndex) {
                    continue
                }
                monthsCount += 1
                if let inflationValue = month.inflation {
                    processingSum *= (1.0 + (inflationValue / 100.0))
                }
            }
        }
        
        inflationCalculatedData = InflationCalculatedData(monthsCount: monthsCount, value: (1.0 - (startSum / processingSum)) * 100.0)
        
    }
    
}

//MARK: Presenter input
extension InflationCalculatorPresenter: InflationCalculatorPresenterInput {
    func didUpdateSelectedItem(newIndex: Int, type: InflationCalculatorPickerViewAdapterType) {
        switch type {
        case .startYear:
            selectedStartYear = Int(startYearsStrings[newIndex])!
            if selectedStartYear ?? 0 > selectedEndYear ?? 0 {
                selectedEndYear = selectedStartYear
                view?.set(endYearIndex: 0)
            }
        case .endYear:
            selectedEndYear = Int(endYearsStrings[newIndex])!
        case .startMonth:
            selectedStartMonthIndex = newIndex
            if selectedStartMonthIndex ?? 0 > selectedEndMonthIndex ?? 0 {
                selectedEndMonthIndex = selectedStartMonthIndex
                view?.set(endMonthIndex: 0)
            }
        case .endMonth:
            selectedEndMonthIndex = newIndex
        }
        
        updateData()
    }
    
    func didLoad() {
        viewIsReady = true
        if !inflationService.hasData {
            view?.showLoader()
        } else {
            updateData()
        }
    }
    
    func didPressedRepeatButton() {
        fetchData()
    }
    
}

//MARK: Service output
extension InflationCalculatorPresenter: InflationServiceOutput {
    func didFail(with error: Error?) {
        if !viewIsReady {
            return
        }
        view?.show(error: error?.localizedDescription ?? UnknownError().localizedDescription)
    }
    
    func didUpdate(with data: Results<InflationYear>) {
        updateData()
    }
    
}


