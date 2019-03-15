//
//  GetInflationDataRequest.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

final class GetInflationDataRequest: RequestProtocol {
    var url: URL {
        let baseURL = URL(string: CommonConstants.baseURLString)!
        return baseURL.appendingPathComponent("ytaxi-testing/inflation.csv")
    }
    
    var HTTPMethod: String {
        return "GET"
    }
}
