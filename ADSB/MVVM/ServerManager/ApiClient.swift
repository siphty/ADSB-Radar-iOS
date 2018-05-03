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
//import AFNetworking

class ApiClient: ApiService {
    
    
    func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus> {
        return Observable<RequestStatus>.create { observable -> Disposable in
            self.networkRequest(config, completionHandler: { (data, error) in
                guard let data = data else {
                    if let error = error {
                        observable.onNext(RequestStatus.fail(error))
                    } else {
                        observable.onNext(RequestStatus.fail(RequestError("Parse JSON information failed.")))
                    }
                    observable.onCompleted()
                    return
                }
                observable.onNext(RequestStatus.success(data as AnyObject))
                observable.onCompleted()
            })
            return Disposables.create()
            }.share()
    }
    
    // MARK: conform to ApiService protocol. For new class inherit from ApiClient class, you can overwrite this function and use any other HTTP networking libraries. Like in Unit test, I create MockApiClient which request network by load local JSON file.
    
    func networkRequest(_ config: ApiConfig, completionHandler: @escaping ((Data?, RequestError?) -> Void)) {
//        networkRequestByAFNetworking(config, completionHandler: completionHandler)
        networkRequestByAlamoFire(config, completionHandler: completionHandler)
//        networkRequestByNSURLSession(config, completionHandler: completionHandler)
//        networkRequestByNSURLConnection(config, completionHandler: completionHandler)
    }
    
}

// Other Network request methods
// Conform to ApiService protocol. For new class inherit from ApiClient class,
// you can overwrite this function and use any other HTTP networking libraries.
// Like in Unit test, I created MockApiClient which request network by load local JSON file.
extension ApiClient {
    
    func networkRequestByAlamoFire(_ config: ApiConfig, completionHandler: @escaping ((_ jsonResponse: Data?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        let url = config.getFullUrl()
        Alamofire.request(url).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.result.value else {
                print("Error: \(String(describing: response.result.error))")
                completionHandler(nil, RequestError((response.result.error?.localizedDescription)!))
                return
            }
            completionHandler(data, nil)
        }
    }
    
    func networkRequestByNSURLSession(_ config: ApiConfig, completionHandler: @escaping ((_ jsonResponse: Data?, _ error: RequestError?) -> Void)) {
        URLCache.shared.removeAllCachedResponses()
        let url = config.getFullUrl()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            self.responseHandler(data, error, completionHandler)
        }
        task.resume()
    }
    
//    func networkRequestByAFNetworking(_ config: ApiConfig, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
//        URLCache.shared.removeAllCachedResponses()
//        let url = config.getFullUrl()
//        let method = config.method
//        let sessionManager = AFHTTPSessionManager()
//        sessionManager.requestSerializer.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//        sessionManager.requestSerializer = AFHTTPRequestSerializer()
//        sessionManager.responseSerializer = AFHTTPResponseSerializer()
//        switch method {
//        case "GET":
//            DispatchQueue.global().async {
//                sessionManager.get(url.absoluteString,
//                                   parameters: nil,
//                                   progress: nil,
//                                   success: { (task, response) in
//                                    let jsonString = String(data: response as! Data, encoding: String.Encoding.ascii)
//                                    let data = jsonString?.data(using: .utf8)
//                                    self.responseHandler(data, nil, completionHandler)
//                },
//                                   failure: { (task: URLSessionDataTask?, error) in
//                                    self.responseHandler(nil, error, completionHandler)
//                })
//            }
//        case "POST":
//            return
//        case "PUT":
//            return
//        case "DELETE":
//            return
//        case "OPTIONS":
//            return
//        case "CONNECT":
//            return
//        case "HEAD":
//            return
//        default:
//            return
//        }
//    }
    
    fileprivate func responseHandler(_ data: Data?, _ error: Error?, _ completionHandler: @escaping ((_ jsonResponse: Data?, _ error: RequestError?) -> Void)){
        completionHandler(data, RequestError(error?.localizedDescription ?? "Error with no message"))
    }
}

