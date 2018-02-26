//
//  GeofenceManager.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 26/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation
import CoreLocation

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class GeofenceManager {
    
    static let sharedInstance = GeofenceManager()
    var geotifications: [Geotification] = []
    var locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    fileprivate init() {
        if let location = currentCoordinate {
            fetchGeolocationsWithLocation(location)
        }
    }
    
    // MARK: Loading and saving functions
    func fetchGeolocationsWithLocation(_ currentCoordinate: CLLocationCoordinate2D) {
        if geotifications.count > 0 {
            let _ = geotifications.map {
                self.stopMonitoring(geotification: $0)
            }
            geotifications.removeAll()
        } else {
            geotifications = []
        }
    }
    
    func loadAllGeotifications(with coordinate: CLLocationCoordinate2D) {
        //TODO: get geofences around coordinate
        
        saveAllGeoNotifications()
    }
    
    func saveAllGeoNotifications() {
        UserDefaults.standard.removeObject(forKey: PreferencesKeys.savedItems)
        //        UserDefaults.standard.remove(PreferencesKeys.savedItems)
        var items: [Data] = []
        for geotification in geotifications {
            let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
    }
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        
        switch geotification.eventType {
        case .onEntry:
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
        case .onExit:
            region.notifyOnEntry = false
            region.notifyOnExit = true
            
        case .both:
            region.notifyOnEntry = true
            region.notifyOnExit = true
        }
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            //            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            //            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        let region = self.region(withGeotification: geotification)
        if !geotifications.contains(geotification) {
            geotifications.append(geotification)
            locationManager.startMonitoring(for: region)
        }
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            if geotifications.contains(geotification) {
                geotifications.remove(at: geotifications.index(of: geotification)!)
                locationManager.stopMonitoring(for: circularRegion)
                saveAllGeoNotifications()
            }
        }
    }
    
    func fetchMonitoredRegionBy(_ identifier: String) -> Geotification? {
        for geo in geotifications {
            if geo.identifier == identifier {
                return geo
            }
        }
        return nil
    }
}
