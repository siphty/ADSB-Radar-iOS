//
//  RemoteADSBViewModel.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 26/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class AdsbExchangeViewModel {
    
    let disposeBag = DisposeBag()
    
    var aeResponse = Variable<AEResponse?>(nil)
    var airecrafts: Observable<[Aircraft]>? = nil
    var radius = Variable<Int>(30)
    var apiService: ApiService? = nil 
    var locationManager: CLLocationManager? = nil
    var isIndicatorHiding = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    
    init(_ apiService: ApiService) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationManager = appDelegate.locationManager
        self.apiService = apiService
        bindAircraftsData()
        startFetchAircrafts()
    }
    
    fileprivate func bindAircraftsData() {
        
    }
    
    fileprivate func startFetchAircrafts() {
    
    }
    
    func stopFetchAircrafts() {
        
    }
    
    fileprivate func fetchAircrafts() {
        guard let apiService = apiService else { return }
        guard let locationManager = locationManager else { return }
        var currentLocation: CLLocation? = nil
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 11.0, *) {
                    locationManager.requestAlwaysAuthorization()
                } else {
                    locationManager.requestWhenInUseAuthorization()
                }
            case .authorizedAlways, .authorizedWhenInUse:
                currentLocation = locationManager.location
            }
        } else {
            print("Location services are not enabled")
        }
        guard let currentLocationSaft = currentLocation else { return }
        apiService.fetchRestfulApi(ApiConfig.aircrafts(currentLocationSaft, radius.value))
            .subscribe(onNext: { status in
                self.isIndicatorHiding.value = true
                switch status {
                case .success(let apiResponse):
                    guard let apiResponseSafe = apiResponse as? AEResponse else { return }
                    self.aeResponse.value = apiResponseSafe
//                    self.airecrafts = apiResponseSafe.aircrafts
//                    self.isAlertShowing.value = false
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                    self.isAlertShowing.value = true
                }
            }, onError: { error in
                print(error.localizedDescription)
                self.airecrafts = nil
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
