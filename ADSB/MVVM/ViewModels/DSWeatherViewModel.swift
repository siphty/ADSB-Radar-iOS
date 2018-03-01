//
//  DSWeatherViewModel.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 1/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class DSWeatherViewModel {
    let disposeBag = DisposeBag()
    var apiService: ApiService? = nil
    var dsResponse = Variable<DSResponse?>(nil)
    var hourlyData: Observable<[WeatherDetail]>? = nil
    var dailyData = Variable<[WeatherDetail]>([])
    var cityName = Variable<String>("Not found")
    var isLoading = Variable<Bool>(false)
    
    init(_ apiService: ApiService) {
        bindHourlyData()
        
        self.apiService = apiService
        fetchWeatherInfo(apiService)
    }
    
    fileprivate func fetchWeatherInfo(_ apiService: ApiService) {
        self.isLoading.value = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let locationManager = appDelegate.locationManager
        var location: CLLocation? = nil
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 11.0, *) {
                    locationManager.requestAlwaysAuthorization()
                } else {
                    locationManager.requestWhenInUseAuthorization()
                }
            case .authorizedAlways, .authorizedWhenInUse:
                location = locationManager.location
            }
        } else {
            print("Location services are not enabled")
        }
        guard let locationSafe = location else { return }
        apiService.fetchRestfulApi(ApiConfig.weather(locationSafe))
            .subscribe(onNext: { status in
                switch status {
                case .success(let apiResponse):
                    guard let apiResponseSafe = apiResponse as? DSResponse else { return }
                    self.dsResponse.value = apiResponseSafe
                    self.isLoading.value = false
                case .fail(let error):
                    print(error.errorDescription ?? "Faild to load weather data")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }

    fileprivate func bindHourlyData() {
        hourlyData = dsResponse.asObservable().map {
            if let weatherData = $0?.hourly?.data {
                return  weatherData
            }
            return []
        }
    }
}

    
