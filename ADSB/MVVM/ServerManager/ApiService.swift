//
//  ApiService.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

enum RequestStatus {
    case success(AnyObject?)
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

enum  ApiConfig {
    case aircrafts(CLLocation, Int)
    case weather(CLLocation)
    case localAircrafts
    
    //AE: AdsbExchange
    fileprivate static let AEBaseUrl = "http://public-api.adsbexchange.com"
    //DS: DarkSky
    fileprivate static let DSBaseUrl = "https://api.darksky.net"
    fileprivate static let DSApiKey = "60cc7f28d75d3f655f5f354338af0d99"
    //RPi: Raspberry Pi
    fileprivate static let RPiBaseUrl = "192.168.1.1"
    //Airport: local
    
    var urlPath: String {
        switch self {
        case .aircrafts(let location, let radius):
            return "/VirtualRadar/AircraftList.json?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&fDstL=0&fDstU=\(radius)"
        case .weather(let location):
            return "/forecast/\(ApiConfig.DSApiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)"
        case .localAircrafts:
            return ":30003"
        }
    }
    
    func getFullUrl() -> URL {
        var baseUrl: String!
        switch self {
        case .aircrafts(_):
            baseUrl = ApiConfig.AEBaseUrl
        case .weather(_):
            baseUrl = ApiConfig.DSBaseUrl
        case .localAircrafts:
            baseUrl = ApiConfig.RPiBaseUrl
        }
        
        if let url = URL(string: baseUrl + self.urlPath)  {
            return url
        } else {
            return URL(string: baseUrl)!
        }
    }
}

protocol ApiService {
    func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus>
    func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void))
    func tcpConnect()
}
