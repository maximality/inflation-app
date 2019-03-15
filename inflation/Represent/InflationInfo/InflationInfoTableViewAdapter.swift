//
//  InflationInfoTableViewAdapter.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import UIKit
import RealmSwift

protocol InflationInfoTableViewAdapterInput: class {
    func set(data: Results<InflationYear>)
    func set(tableView: UITableView)
}

protocol InflationInfoTableViewAdapterOutput: class {
    
}

final class InflationInfoTableViewAdapter: NSObject {
    
    fileprivate struct Constants {
        static let estimatedRowHeight: CGFloat = 44
        static let tableViewHeaderHeight: CGFloat = 65
    }
    
    //MARK: Properties
    fileprivate var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = Constants.estimatedRowHeight
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(R.nib.inflationCell)
            tableView.register(UINib(resource: R.nib.inflationYearHeader), forHeaderFooterViewReuseIdentifier: R.nib.inflationYearHeader.name)
        }
    }
    
    fileprivate weak var output: InflationInfoTableViewAdapterOutput?
    fileprivate var years: Results<InflationYear>?
    fileprivate var months: [Int : Results<InflationMonth>] = [:] //key is year
    fileprivate var expandedYears: [Int] = [] //years to expand (we need this to save state while reloading)
    
    //MARK: Init
    init(output: InflationInfoTableViewAdapterOutput) {
        self.output = output
        super.init()
    }
    
    //MARK: Data reload
    private func reloadData() {
        defer { tableView.reloadData() }
        months.removeAll()
        guard let years = years else {
            return
        }
        for year in years {
            if expandedYears.contains(year.year) {
                months[year.year] = year.sortedMonths
            }
        }
    }
}


//MARK: UITableViewDelegate&DataSource
extension InflationInfoTableViewAdapter: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return years?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let year = years?[section],
            let monthsCount = months[year.year]?.count else {
            return 0
        }
        return monthsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inflationCell, for: indexPath)!
        guard let year = years?[indexPath.section],
            let month = months[year.year]?[indexPath.row] else {
            return cell
        }
        cell.configure(with: month)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.inflationYearHeader.name) as! InflationYearHeader
        guard let year = years?[section] else {
            return header
        }
        header.configure(with: year, collapsed: !expandedYears.contains(year.year), section: section)
        header.toggleDelegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.tableViewHeaderHeight
    }
}

//MARK: InflationInfoTableViewAdapterInput
extension InflationInfoTableViewAdapter: InflationInfoTableViewAdapterInput {
    func set(data: Results<InflationYear>) {
        self.years = data
        reloadData()
    }
    
    func set(tableView: UITableView) {
        self.tableView = tableView
    }
}

extension InflationInfoTableViewAdapter: CollapsibleTableViewHeaderDelegate {
    func toggleHeader(_ header: UITableViewHeaderFooterView, section: Int) {
        guard let year = years?[section] else {
            return
        }
        let index = expandedYears.lastIndex(of: year.year)
        if index != nil { //expanded
            expandedYears.remove(at: index!)
            months[year.year] = nil
        } else {
            expandedYears.append(year.year)
            months[year.year] = year.sortedMonths
        }
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
