//
//  AirdromeCommon.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 23/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import MapKit

final class AirdomeCommon {
    
    static let sharedInstance =  AirdomeCommon()
    var airports: [Airport] = []
    var runways: [Runway] = []
    
    /// Load the CSV file and parse it
    func parseAirportCSV() {
        // TODO: if CoreData has been preloaded. Skip parse Runway CSV
        let separater = ","
        removeAllAirport()
        guard let contentsOfUrl = Bundle.main.url(forResource:"airports", withExtension: "csv") else { return }
        var content = ""
        do {
            content = try String(contentsOf: contentsOfUrl, encoding: .utf8)
        } catch {
            print("error")
        }
//        if let content = String(   contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding, error: error) {
            let lines = content.components(separatedBy: .newlines) as [String]
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        print("====================        Start preload airport table       ======================== \(hour):\(minutes)")
        lines.forEach { line in
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                if line.range(of: "\"") != nil {
                    var lineToScan = line
                    var outcomeString: NSString? = nil
                    let value = AutoreleasingUnsafeMutablePointer<NSString?>(&outcomeString)
                    var lineScanner = Scanner(string: lineToScan)
                    while !lineScanner.isAtEnd {
                        let scannerString = lineScanner.string
                        let index = scannerString.index(scannerString.startIndex , offsetBy: 1)
                        if String(lineScanner.string[..<index]) == "\"" {
                            lineScanner.scanLocation += 1
                            _ = lineScanner.scanUpTo("\"", into: value)
                            lineScanner.scanLocation += 1
                        } else {
                            _ = lineScanner.scanUpTo(separater, into: value)
                        }
                        
                        // Store the value into the values array
                        values.append(value.pointee! as String)
                        // Retrieve the unscanned remainder of the string
                        if lineScanner.scanLocation < lineScanner.string.count {
                            let index = scannerString.index(lineToScan.startIndex, offsetBy: lineScanner.scanLocation + 1)
                            lineToScan = String(scannerString[index...])
                        } else {
                            lineToScan = ""
                        }
                        lineScanner = Scanner(string: lineToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the separater (e.g. comma)
                } else  {
                    values = line.components(separatedBy: separater)
                }
                // Put the values into the tuple and add it to the items array
                guard values.count != 0 else {
                    print("Got no airport on this line")
                    return
                }
                saveAirport(values)
            }
        }
    
        let endHour = calendar.component(.hour, from: Date())
        let endMinutes = calendar.component(.minute, from: Date())
        print("====================        END preload airport table       ========================\(endHour):\(endMinutes)")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Could not save. ")//\(error), \(error.userInfo)")
        }
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isPreloaded")
    }
    
    func saveAirport(_ values: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let airport = Airport(context: context)
        let idString: String = values[0]
        guard idString.isInt else { return }
        airport.id = Int64(idString) ?? 0
        airport.ident = values[1]
        airport.type = values[2]
        airport.name = values[3]
        airport.latitude_deg = Double(values[4]) ?? 0
        airport.longitude_deg = Double(values[5]) ?? 0
        airport.elevation_ft = Int16(values[6]) ?? 0
        airport.continent = values[7]
        airport.iso_country = values[8]
        airport.iso_region = values[9]
        airport.municipality = values[10]
        airport.scheduled_service = (values[11] == "yes")
        airport.gps_code = values[12]
        airport.iata_code = values[13]
        airport.local_code = values[14]
        airport.home_link = values[15]
        if values.count >= 17 {
            airport.wikipedia_link = values[16]
        }
        if values.count >= 18 {
            airport.keywords = values[17]
        }
        
    }

    func removeAllAirport() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Airport")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}

extension AirdomeCommon {
    func usePrePopulatedDB() {
        
    }
    
    func fetchNearestAirport(in span: MKCoordinateSpan, at location: CLLocationCoordinate2D, completion : @escaping (_ airports: [Airport]?) -> Void) {
        var airports: [Airport] = []
//        var longitudeRange: Double = Double(location.coordinate.longitude) + (radius / 111)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            let request = Airport.getFetchRequest()
            let maxLatitudeDegree = Double(location.latitude) + Double(span.latitudeDelta)/2
            let minLatitudeDegree = Double(location.latitude) - Double(span.latitudeDelta)/2
            let maxLongitudeDegree = Double(location.longitude) + Double(span.longitudeDelta)/2
            let minLongitudeDegree = Double(location.longitude) - Double(span.longitudeDelta)/2
            
            let maxLatitudePredicate = NSPredicate(format: "latitude_deg < %f", maxLatitudeDegree)
            let minLatitudePredicate = NSPredicate(format: "latitude_deg > %f", minLatitudeDegree)
            let maxLongitudePredicate = NSPredicate(format: "longitude_deg < %f", maxLongitudeDegree)
            let minLongitudePredicate = NSPredicate(format: "longitude_deg > %f", minLongitudeDegree)
            let andPredicate = NSCompoundPredicate.init(type: .and, subpredicates: [maxLatitudePredicate, minLatitudePredicate, maxLongitudePredicate, minLongitudePredicate])
            request.predicate = andPredicate
            airports = try context.fetch(request)
        }
        catch {
            print("Fetching Airport Failed")
            completion(nil)
        }
        completion(airports)
    }
    
    func fetchRunway(on airport:Airport, completion: @escaping (_ runways: [Runway]?) -> Void){
        var runways: [Runway] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let airport_ident = airport.ident else {
            return
        }
        do {
            let request = Runway.getFetchRequest()
            let runwayPredicate = NSPredicate(format: "airport_ident == %@", airport_ident)
            request.predicate = runwayPredicate
            runways = try context.fetch(request)
        } catch {
            print("Fetching Runway Failed")
            completion(nil)
        }
        completion(runways)
    }
}


extension AirdomeCommon {

    func parseRunwayCSV() {
        // TODO: if CoreData has been preloaded. Skip parse Runway CSV
        // Load the CSV file and parse it
        let separater = ","
        removeAllRunways()
        guard let contentsOfUrl = Bundle.main.url(forResource:"runways", withExtension: "csv") else { return }
        var content = ""
        do {
            content = try String(contentsOf: contentsOfUrl, encoding: .utf8)
        } catch {
            print("error")
        }
//        if let content = String(   contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding, error: error) {
        let lines = content.components(separatedBy: .newlines) as [String]
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        print("====================        Start preload  Runway table       ======================== \(hour):\(minutes)")
        lines.forEach { line in
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                if line.range(of: "\"") != nil {
                    var lineToScan = line
                    var outcomeString: NSString? = nil
                    let value = AutoreleasingUnsafeMutablePointer<NSString?>(&outcomeString)
                    var lineScanner = Scanner(string: lineToScan)
                    while !lineScanner.isAtEnd {
                        let scannerString = lineScanner.string
                        let index = scannerString.index(scannerString.startIndex , offsetBy: 1)
                        if String(lineScanner.string[..<index]) == "\"" {
                            lineScanner.scanLocation += 1
                            _ = lineScanner.scanUpTo("\"", into: value)
                            lineScanner.scanLocation += 1
                        } else {
                            _ = lineScanner.scanUpTo(separater, into: value)
                        }

                        // Store the value into the values array
                        values.append(value.pointee! as String)

                        // Retrieve the unscanned remainder of the string
                        
                        if lineScanner.scanLocation < lineScanner.string.count {
                            let index = scannerString.index(lineToScan.startIndex, offsetBy: lineScanner.scanLocation + 1)
                            lineToScan = String(scannerString[index...])
                        } else {
                            lineToScan = ""
                        }
                        lineScanner = Scanner(string: lineToScan)
                    }

                    // For a line without double quotes, we can simply separate the string
                    // by using the separater (e.g. comma)
                } else  {
                    values = line.components(separatedBy: separater)
                }
                // Put the values into the tuple and add it to the items array
                guard values.count != 0 else {
                    print("Got no runway on this line")
                    return
                }
                saveRunway(values)
            }
        }

        let endHour = calendar.component(.hour, from: Date())
        let endMinutes = calendar.component(.minute, from: Date())
        print("====================        END preload Runway table       ========================\(endHour):\(endMinutes)")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Could not save. ")//\(error), \(error.userInfo)")
        }

        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isPreloaded")
    }
    
    
    func removeAllRunways() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Runway")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func saveRunway(_ values: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let runway = Runway(context: context)
        let idString: String = values[0]
        guard idString.isInt else { return }
        runway.id = Int32(idString) ?? 0
        runway.airport_ref = Int32(values[1]) ?? 0
        runway.airport_ident = values[2]
        runway.length_ft = Int16(values[3]) ?? 0
        runway.width_ft = Int16(values[4]) ?? 0
        runway.surface = values[5]
        runway.lighted = (Int(values[6]) == 1)
        runway.closed = (Int(values[7]) == 1)
        runway.le_ident = values[8]
        runway.le_latitude_deg = Double(values[9]) ?? 0
        runway.le_longitude_deg = Double(values[10]) ?? 0
        runway.le_elevation_ft = Int16(values[11]) ?? 0
        runway.le_heading_degT = Double(values[12]) ?? 0
        runway.le_displaced_threshold_ft = Int16(values[13]) ?? 0
        runway.he_ident = values[14]
        runway.he_latitude_deg = Double(values[15]) ?? 0
        runway.he_longitude_deg = Double(values[16]) ?? 0
        runway.he_elevation_ft = Int16(values[17]) ?? 0
        runway.he_heading_degT = Double(values[18]) ?? 0
//        runway.he_displaced_threshold_ft = values.indices.contains(19) ?
//            (Int16(values[19]) ?? 0) : 0
        guard let heDisplacedThresholdFt = values[safe: 19] else { return }
        runway.he_displaced_threshold_ft = Int16(heDisplacedThresholdFt) ?? 0
    }
}
