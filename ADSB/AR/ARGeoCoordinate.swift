////
////  ARGeoCoordinate.swift
////  ADSB Radar
////
////  Created by Yi JIANG on 10/7/17.
////  Copyright © 2017 Siphty. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//
//class ARGeoCoordinate: NSObject {
//    
//    var dataObject : Any?
//    var radialDistance: Double?
//    var inclination: Double?
//    var azimuth: Double?
//    var geoLocation: CLLocation?
//    
//    func degreesToRadians(x: Double) -> Double {
//        return .pi * x / 180.0
//    }
//    func radiansToDegrees(x: Double) -> Double {
//        return x * (180.0 / .pi)
//    }
//    
//    func coordinate(with location: CLLocation) -> ARGeoCoordinate? {
//        return nil
//    }
//    
//    func calibrate(using origin: CLLocation, _ useAltitude: Bool) {
//        
//    }
//    
//    func hash() -> UInt {
//        return 0
//    }
//    
//    override func isEqual(_ other: (Any)?) -> Bool {
//        if other == self {
//            return true
//        }
//        if !other || !(other is ARGeoCoordinate ) {
//            return false
//        }
//        return isEqual(to: other)
//    }
//    
//    func isEqual(to otherCoordinate: ARGeoCoordinate) -> Bool {
//        if self == otherCoordinate { return true }
//        
//        var equal = radialDistance == otherCoordinate.radialDistance
//        equal = equal && (inclination == otherCoordinate.inclination)
//        equal = equal && (azimuth == otherCoordinate.azimuth)
//        equal = equal && (dataObject == otherCoordinate.dataObject)
//        return equal
//    }
//    
//    fileprivate func description() -> String {
//        return String(format: "r: %.3fm | φ: %.3f° | θ: %.3f°", radialDistance!, radiansToDegrees(azimuth), radiansToDegrees(inclination))
//    }
//}
//
//
