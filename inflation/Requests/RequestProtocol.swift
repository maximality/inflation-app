//
//  RequestProtocol.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var url: URL { get }
    var HTTPMethod: String { get }
}
