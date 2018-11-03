//
//  MKMapView+Airport.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 9/8/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import Foundation
import MapKit

//MARK: -
//MARK: Airports
extension MKMapView {
    func drawRunway(on airport: Airport){
        AirdomeCommon.sharedInstance.fetchRunway(on: airport) { (runways) in
            guard let runways = runways else {return}
            for runway in runways {
                
            }
        }
    }
    
    func drawAirportRestrictRegion() {
        AirdomeCommon.sharedInstance.fetchNearestAirport(in: region.span, at: region.center, completion: { (airports) in
            guard let airports = airports else { return }
            for airport in airports {
                var isDrawn = false
                for overlay in self.overlays {
                    guard airport.ident != nil else {
                        isDrawn = true
                        break
                    }
                    let title = String("Airport : \(airport.ident!)")
                    if (overlay.title!!.range(of: title) != nil) {
                        isDrawn = true
                        break
                    }
                }
                if isDrawn {
                    isDrawn = false
                    continue
                }
                guard let airportType = airport.type else { continue }
                let airdromeCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(airport.latitude_deg), longitude: CLLocationDegrees(airport.longitude_deg))
                
                if airportType == "small_airport" {
                    var airportNFA45Circle: MKCircle?
                    airportNFA45Circle = MKCircle(center: airdromeCoordinate, radius: 2000)
                    guard airport.ident != nil else { continue }
                    airportNFA45Circle!.title = "Airport : \(airport.ident!) NFA45"
                    self.addOverlay(airportNFA45Circle!)
                    
                    var airportNFZCircle: MKCircle?
                    airportNFZCircle = MKCircle(center: airdromeCoordinate, radius: 500)
                    guard airport.ident != nil else { continue }
                    airportNFZCircle!.title = "Airport : \(airport.ident!) NFZ"
                    self.addOverlay(airportNFZCircle!)
                    
                } else if airportType == "medium_airport"{
                    var airportCircle: MKCircle?
                    airportCircle = MKCircle(center: airdromeCoordinate, radius: 5500)
                    guard airport.ident != nil else { continue }
                    airportCircle!.title = "Airport : \(airport.ident!) NFZ"
                    self.addOverlay(airportCircle!)
                    
                } else if airportType == "large_airport"{
                    var airportCircle: MKCircle?
                    airportCircle = MKCircle(center: airdromeCoordinate, radius: 6500)
                    guard airport.ident != nil else { continue }
                    airportCircle!.title = "Airport : \(airport.ident!) NFZ"
                    self.addOverlay(airportCircle!)
                    
                } else if airportType == "heliport" {
                    var helipadNFA45Circle: MKCircle?  //No Fly Above 45 m
                    helipadNFA45Circle = MKCircle(center: airdromeCoordinate, radius: 2000)
                    guard airport.ident != nil else { continue }
                    helipadNFA45Circle!.title = "Airport : \(airport.ident!) NFA45"
                    self.addOverlay(helipadNFA45Circle!)
                    
                    var helipadNFZCircle: MKCircle?    // No Fly Zone
                    helipadNFZCircle = MKCircle(center: airdromeCoordinate, radius: 500)
                    guard airport.ident != nil else { continue }
                    helipadNFZCircle!.title = "Airport : \(airport.ident!) NFZ"
                    self.addOverlay(helipadNFZCircle!)
                    
                } else if airportType == "seaplane_base"{
                    var airportNFA45Circle: MKCircle?
                    airportNFA45Circle = MKCircle(center: airdromeCoordinate, radius: 2000)
                    guard airport.ident != nil else { continue }
                    airportNFA45Circle!.title = "Airport : \(airport.ident!) NFA45"
                    self.addOverlay(airportNFA45Circle!)
                    
                    var airportNFZCircle: MKCircle?
                    airportNFZCircle = MKCircle(center: airdromeCoordinate, radius: 500)
                    guard airport.ident != nil else { continue }
                    airportNFZCircle!.title = "Airport : \(airport.ident!) NFZ"
                    self.addOverlay(airportNFZCircle!)
                    
                } else if airportType == "balloonport"{
                    
                } else if airportType == "closed"{
                    
                }
            }
        })
    }
    
    
    func removeAllAirportRestrictRegion() {
        for overlay in overlays {
            guard let overlayTitle = overlay.title else { continue }
            if (overlayTitle!.range(of: "Airport" ) != nil) {
                removeOverlay(overlay)
            }
        }
    }
    
}
