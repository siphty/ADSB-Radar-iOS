//
//  ApiClient.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation

class ApiClient: ApiService {
    
    // MARK: conform to ApiService protocol. For new class inherit from ApiClient class, you can overwrite this function and use any other HTTP networking libraries. Like in Unit test, I create MockApiClient which request network by load local JSON file.
    func networkRequest(_ config: ApiConfig, completionHandler: @escaping ((Data?, RequestError?) -> Void)) {
        networkRequestByNSURLSession(config, completionHandler: completionHandler)
    }
    
}

// Other Network request methods
// Conform to ApiService protocol. For new class inherit from ApiClient class,
// you can overwrite this function and use any other HTTP networking libraries.
// Like in Unit test, I created MockApiClient which request network by load local JSON file.
extension ApiClient {
    
    func networkRequestByNSURLSession(_ config: ApiConfig, completionHandler: @escaping ((_ jsonResponse: Data?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        let url = config.getFullUrl()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            self.responseHandler(data, error, completionHandler)
        }
        task.resume()
    }
    
    fileprivate func responseHandler(_ data: Data?, _ error: Error?, _ completionHandler: @escaping ((_ jsonResponse: Data?, _ error: RequestError?) -> Void)){
        completionHandler(data, RequestError(error?.localizedDescription ?? "Error with no message"))
    }
}

