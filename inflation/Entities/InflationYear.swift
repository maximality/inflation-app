//
//  Year.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import RealmSwift

final class InflationYear: Object {
    @objc dynamic var year = 0
    let months = List<InflationMonth>()
    private var inflationValue: RealmOptional<Float> = RealmOptional<Float>.init(nil)

    var sortedMonths: Results<InflationMonth> {
        return months.sorted(byKeyPath: #keyPath(InflationMonth.orderIndex))
    }
    
    var inflation: Float? {
        get {
            return inflationValue.value
        } set {
            inflationValue = RealmOptional<Float>(newValue)
        }
    }
}
