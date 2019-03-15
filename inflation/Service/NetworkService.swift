//
//  NetworkService.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import Foundation

typealias RequestResult = (Data?, Error?) -> Void

final class NetworkService {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    var dataTask: URLSessionDataTask?
    
    func performRequest(_ request: RequestProtocol, completion: @escaping RequestResult) {
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: request.url) { data, response, error in
            defer { self.dataTask = nil }
            completion(data, error)
        }
        
        dataTask?.resume()
    }
}
