//
//  Notifications.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 26/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation


//MARK: LocationManager 
struct LMNotification {
    static let didUpdateLocations = "LocationManagerDidUpdateLocations"
    static let didUpdateHeading = "LocationManagerDidUpdateHeading"
    static let didDetermineState = "LocationManagerDidDetermineState"
    static let didRangeBeacons = "LocationManagerDidRangeBeaconss"
    static let rangingBeaconsDidFailForBeaconRegion = "LocationManagerRangingBeaconsDidFailForBeaconRegion"
    static let didEnterRegion = "LocationManagerDidEnterRegion"
    static let didExitRegion = "LocationManagerDidExitRegion"
    static let didFailWithError = "LocationManagerDidFailWithError"
    static let didChangeAuthorization = "LocationManagerDidChangeAuthorization"
    static let didStartMonitoringForRegion = "LocationManagerDidStartMonitoringForRegion"
    static let didUpdateLocationsForGeochats = "LocationManagerDidUpdateLocationsForGeoChats"
}
