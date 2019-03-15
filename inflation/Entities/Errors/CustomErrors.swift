//
//  CustomErrors.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

class UnknownError: Error {
    var localizedDescription: String {
        return R.string.localizable.errorUnknown()
    }
}

class DecodingError: Error {
    var localizedDescription: String {
        return R.string.localizable.errorDecodingError()
    }
}

class CSVFormatError: Error {
    var localizedDescription: String {
        return R.string.localizable.errorCsvFormatError()
    }
}

