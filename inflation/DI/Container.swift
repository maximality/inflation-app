//
//  Container.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        //MARK: Services
        defaultContainer.register(NetworkService.self) { (_) in
            NetworkService()
            }.inObjectScope(.container)
        defaultContainer.register(RealmService.self) { (_) in
            RealmService()
            }.inObjectScope(.container)
        defaultContainer.register(DateFormatHelper.self) { (_) in
            DateFormatHelper()
            }.inObjectScope(.container)
        defaultContainer.register(InflationService.self) { (r) in
            InflationService.init(realmService: r.resolve(RealmService.self)!, networkService: r.resolve(NetworkService.self)!, dateFormatHelper: r.resolve(DateFormatHelper.self)!)
            }.inObjectScope(.container)
        
        //MARK: Views&Presenters
        defaultContainer.storyboardInitCompleted(TabBarController.self) { (_, _) in
            
        }
        
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _,_ in }
        
        //MARK: Views&Presenters
        defaultContainer.storyboardInitCompleted(InflationInfoViewController.self) { (res, c) in
            c.presenter = InflationInfoPresenter(view: c, inflationService: res.resolve(InflationService.self)!)
            c.adapter = InflationInfoTableViewAdapter(output: c)
        }
        
        defaultContainer.storyboardInitCompleted(InflationCalculatorViewController.self) { (res, c) in
            c.presenter = InflationCalculatorPresenter(view: c, inflationService: res.resolve(InflationService.self)!)
            c.startYearAdapter = InflationCalculatorPickerViewAdapter(output: c, type: .startYear)
            c.startMonthAdapter = InflationCalculatorPickerViewAdapter(output: c, type: .startMonth)
            c.endYearAdapter = InflationCalculatorPickerViewAdapter(output: c, type: .endYear)
            c.endMonthAdapter = InflationCalculatorPickerViewAdapter(output: c, type: .endMonth)
        }
        
        
    }
}
