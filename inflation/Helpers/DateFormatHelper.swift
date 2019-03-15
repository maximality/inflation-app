//
//  DateFormatHelper.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

final class DateFormatHelper {
    
    let dateFormatter = DateFormatter()
    
    func getMonthName(by number: Int) -> String {
        return dateFormatter.monthSymbols[number]
    }
}
