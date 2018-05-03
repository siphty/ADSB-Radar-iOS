//
//  AEAircraftsViewModel.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 26/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class AEAircraftsViewModel {
    
    let disposeBag = DisposeBag()
    
    var aeResponse = Variable<AEResponse?>(nil)
    var airecrafts = Variable<[Aircraft]?>(nil)
    var radius = Variable<Int>(30)
    var apiClient: ApiClient? = nil
    var locationManager: CLLocationManager? = nil
    var isIndicatorHiding = Variable<Bool>(false)
    var isAlertShowing = Variable<Bool>(false)
    
    init(_ apiClient: ApiClient) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationManager = appDelegate.locationManager
        self.apiClient = apiClient
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
        guard let apiClient = apiClient else { return }
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
        guard let currentLocationSafe = currentLocation else { return }
        apiClient.fetchRestfulApi(ApiConfig.aircrafts(currentLocationSafe, radius.value))
            .subscribe(onNext: { status in
                self.isIndicatorHiding.value = true
                switch status {
                case .success(let apiResponse):
                    guard let apiResponseSafe = apiResponse as? AEResponse else { return }
                    self.aeResponse.value = apiResponseSafe
                    self.airecrafts.value = apiResponseSafe.acList
                    self.isAlertShowing.value = false
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                    self.isAlertShowing.value = true
                }
            }, onError: { error in
                print(error.localizedDescription)
                self.airecrafts.value = nil
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
