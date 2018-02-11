//
//  ADSBExchangeApiService.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RequestStatus {
    case success(ADSBAircraft)
    case fail(RequestError)
}

struct RequestError : LocalizedError {
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    
    private var mMsg : String
    
    init(_ description: String) {
        mMsg = description
    }
}

enum ADSBExchangeApiConfig {
    fileprivate static let baseURLString = "https://api.darksky.net"
}
