//
//  ApiClient.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

class ApiClient: ApiService {
    
    func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus> {
        let url = config.getFullUrl()
        return Observable<RequestStatus>.create { observable -> Disposable in
            self.networkRequest(url, completionHandler: { (json, error) in
                guard let json = json else {
                    if let error = error {
                        observable.onNext(RequestStatus.fail(error))
                    } else {
                        observable.onNext(RequestStatus.fail(RequestError("Parse Weather information failed.")))
                    }
                    observable.onCompleted()
                    return
                }
                var response: AnyObject? = nil
                switch config {
                case .aircrafts(_, _):
                    response = Mapper<AEResponse>().map(JSON: json)
                case .weather(_):
                    response = Mapper<Weather>().map(JSON: json)
                case .localAircrafts:
                    response = Mapper<AEResponse>().map(JSON: json)
                }
                if let response = response {
                    observable.onNext(RequestStatus.success(response))
                    observable.onCompleted()
                } else {
                    observable.onNext(RequestStatus.fail(RequestError("Parse Weather information failed.")))
                    observable.onCompleted()
                }
            })
            return Disposables.create()
            }.share()
    }
    
    // MARK: conform to ApiService protocol. For new class inherit from ApiClient class, you can overwrite this function and use any other HTTP networking libraries. Like in Unit test, I create MockApiClient which request network by load local JSON file.
    func networkRequest(_ url: URL, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        Alamofire.request(url).responseJSON(queue: DispatchQueue.global(), options: .allowFragments) { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("Error: \(String(describing: response.result.error))")
                    completionHandler(nil, RequestError((response.result.error?.localizedDescription)!))
                    return
                }
                completionHandler(json, nil)
        }
    }
    
    func tcpConnect() {
        
    }
}
