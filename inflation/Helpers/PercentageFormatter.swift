//
//  PercentageFormatter.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

extension Float {
    var percentageRepresentation: String {
        return String(format: "%.1f", self)
    }
}
