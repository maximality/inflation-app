//
//  InflationService.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation
import CSV
import RealmSwift

protocol InflationServiceOutput {
    func didFail(with error: Error?)
    func didUpdate(with data: Results<InflationYear>)
}

final class InflationService {
    
    private var realmService: RealmService
    private var networkService: NetworkService
    private var dateFormatHelper: DateFormatHelper
    
    private var data: Results<InflationYear>! {
        didSet {
            notificationToken?.invalidate()
            notificationToken = data.observe({ (change) in
                switch change {
                case .update(_, _, _, _):
                    self.outputs.invoke(invocation: { $0.didUpdate(with: self.data) })
                default: return;
                }
            })
        }
    }
    
    private var notificationToken: NotificationToken?
    
    //MARK: Public
    
    var outputs = MulticastDelegate<InflationServiceOutput>()
    
    var hasData: Bool {
        return data.count > 0
    }
    
    var inflationData: Results<InflationYear> {
        get {
            return data
        }
    }
    
    //MARK: Init
    
    init(realmService: RealmService, networkService: NetworkService, dateFormatHelper: DateFormatHelper) {
        self.realmService = realmService
        self.networkService = networkService
        self.dateFormatHelper = dateFormatHelper
        setDataFetch()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setDataFetch() {
        self.data = realmService.realm.objects(InflationYear.self).sorted(byKeyPath: #keyPath(InflationYear.year), ascending: false)
    }
    
    //MARK: Handlers
    
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        updateData()
    }
    
    private func handleError(error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.outputs.invoke(invocation: { $0.didFail(with: error) })
            } else {
                self.outputs.invoke(invocation: { $0.didFail(with: UnknownError()) })
            }
        }
    }
    
    private func handleNewData(_ data: Data) -> Error? {
        guard let dataString = String.init(data: data, encoding: .utf8) else {
            return DecodingError()
        }
        do {
            let csv = try CSVReader(string: dataString,
                                    hasHeaderRow: true)
            var years = [InflationYear]()
            while let row = csv.next() {
                guard row.count == CommonConstants.entriesInOneRowCount, let yearNumber = Int(row.first!) else {
                    return CSVFormatError()
                }
                let year = InflationYear()
                year.year = yearNumber
                year.inflation = Float(row.last!)
                for i in 1..<row.count - 1 {
                    let monthName = dateFormatHelper.getMonthName(by: i - 1)
                    let inflationValue = Float(row[i])
                    let month = InflationMonth()
                    month.orderIndex = i - 1
                    month.name = monthName
                    month.inflation = inflationValue
                    year.months.append(month)
                }
                years.append(year)
            }
            let realm = realmService.realm
            try! realm.write {
                realm.deleteAll()
                realm.add(years)
            }
        } catch let ex {
            return ex
        }
        return nil
    }
    
    //MARK: Public
    func updateData() {
        let request = GetInflationDataRequest()
        networkService.performRequest(request) { (data, error) in
            guard let data = data, error == nil else {
                self.handleError(error: error)
                return
            }
            if let error = self.handleNewData(data) {
                self.handleError(error: error)
            }
        }
    }
    
}
