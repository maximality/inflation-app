//
//  InflationInfoPresenter.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation
import RealmSwift

protocol InflationInfoPresenterInput: class {
    func didLoad()
    func didPressedRepeatButton()
}

protocol InflationInfoPresenterOutput: class {
    func set(data: Results<InflationYear>)
    func showLoader()
    func dismissLoader()
    func show(error: String)
    func dismissError()
}

final class InflationInfoPresenter {
    
    //MARK: Properties
    
    weak var view: InflationInfoPresenterOutput?
    fileprivate var inflationService: InflationService
    fileprivate var viewIsReady = false
    
    //MARK: Initializer
    
    init(view: InflationInfoPresenterOutput, inflationService: InflationService) {
        self.view = view
        self.inflationService = inflationService
        setUp()
    }
    
    private func setUp() {
        inflationService.outputs.addDelegate(delegate: self)
    }
    
    fileprivate func fetchData() {
        if !inflationService.hasData && viewIsReady {
            view?.dismissError()
            view?.showLoader()
        }
        inflationService.updateData()
    }
    
    fileprivate func updateData() {
        if !viewIsReady {
            return
        }
        if !inflationService.hasData {
            view?.showLoader()
        } else {
            view?.set(data: inflationService.inflationData)
        }
    }
    
}

//MARK: Presenter input
extension InflationInfoPresenter: InflationInfoPresenterInput {
    func didPressedRepeatButton() {
        fetchData()
    }
    
    func didLoad() {
        viewIsReady = true
        updateData()
    }
}


//MARK: Service output
extension InflationInfoPresenter: InflationServiceOutput {
    func didFail(with error: Error?) {
        if !inflationService.hasData {
            view?.show(error: error?.localizedDescription ?? UnknownError().localizedDescription)
        }
    }
    
    func didUpdate(with data: Results<InflationYear>) {
        view?.dismissError()
        view?.dismissLoader()
        view?.set(data: data)
    }
}
