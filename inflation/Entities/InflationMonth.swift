//
//  Month.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import RealmSwift

final class InflationMonth: Object {
    @objc dynamic var name = ""
    @objc dynamic var orderIndex = 0

    private var inflationValue: RealmOptional<Float> = RealmOptional<Float>.init(nil)
    
    private let years = LinkingObjects(fromType: InflationYear.self, property: "months")
    
    var year: InflationYear {
        return years.first! //better crash than non-predicted behavior
    }
    
    var inflation: Float? {
        get {
            return inflationValue.value
        } set {
            inflationValue = RealmOptional<Float>(newValue)
        }
    }
}


