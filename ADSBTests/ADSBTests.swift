//
//  ADSBTests.swift
//  ADSBTests
//
//  Created by Yi JIANG on 4/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import XCTest
import CoreLocation

//@testable import ADSB_Radar

class ADSBTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testAdsbExchangeApiServiceWithCorrectApi(){
        let apiClient = ApiClient()
        let sydLatitude = CLLocationDegrees(-33.873692)
        let sydLongitude = CLLocationDegrees(151.206768)
        let sydneyLocation = CLLocation.init(latitude: sydLatitude, longitude: sydLongitude)
        apiClient.networkRequest(.aircrafts(sydneyLocation, 20)) { (data, error) in
            if error != nil {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                do {
                    let ae = try decoder.decode(AEResponse.self, from: data)
                    print(ae.ac?.first?.callSign)
                } catch {
                    
                }
            }
        }
        //        apiClient.fetchRestfulApi(.aircrafts(sydneyLocation, 20) ).subscribe(onNext: { status in
        //            switch status {
        //            case .success(let apiResponse):
        //                let aeResponse = apiResponse as! AEResponse
        //                let aircrafts = aeResponse.acList
        //                XCTAssertTrue(aircrafts != nil)
        //                XCTAssertTrue(aircrafts!.count > 0)
        //            //MARK: We can test more key:value to verify the decode logic is right.
        //            case .fail(let error):
        //                print(error.errorDescription ?? "Faild to load AdsbExchange data")
        //            }
        //        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func testDarkSkyApiServiceWithCorrectApi(){
        let apiClient = ApiClient()
        let sydLatitude = CLLocationDegrees(-33.873692)
        let sydLongitude = CLLocationDegrees(151.206768)
        let sydneyLocation = CLLocation.init(latitude: sydLatitude, longitude: sydLongitude)
        //        apiClient.fetchRestfulApi(.weather(sydneyLocation)).subscribe(onNext: { status in
        //            switch status {
        //            case .success(let apiResponse):
        //                let dsResponse = apiResponse as! DSResponse
        //                let currentWeather = dsResponse.currently
        //                XCTAssertTrue(currentWeather != nil)
        //            //MARK: We can test more key:value to verify the decode logic is right.
        //            case .fail(let error):
        //                print(error.errorDescription ?? "Faild to load weather data")
        //            }
        //        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


class MockApiClient: ApiClient {
    
    enum JsonFileName: String {
        case aeResponse = "AEResponse"
        case aeResponse_empty = "AEResponse_empty"
        case dsResponse = "DSResponse"
        case dsResponse_empty = "DSResponse_empty"
    }
    
    var jsonFileName = JsonFileName.aeResponse
    
    //    override func fetchRestfulApi(_ config: ApiConfig) -> Observable<RequestStatus> {
    //        return super.fetchRestfulApi(config)
    //    }
    
    //Use mock response data based on the
    override func networkRequest(_ config: ApiConfig, completionHandler: @escaping ((Data?, RequestError?) -> Void)) {
        guard let json = JsonFileLoader.loadJson(fileName: jsonFileName.rawValue) as? Data else {
            completionHandler(nil, RequestError("Parse Weather information failed."))
            return
        }
        completionHandler(json, nil)
    }
}

class JsonFileLoader {
    
    class func loadJson(fileName: String) -> Any? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    return try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        } else {
            print("invalid url")
        }
        return nil
    }
}
