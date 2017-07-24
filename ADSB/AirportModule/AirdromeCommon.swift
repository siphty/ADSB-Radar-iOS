//
//  AirdromeCommon.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 23/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import Foundation
import CoreData


final class AirdomeCommon {
    
    func parseRunwayCSV() {
        
    }
    
    func parseAirportCSV() {
        // Load the CSV file and parse it
        let separater = ","
        if false {
            return //if CoreData has been preloaded.
        }
        removeAllAirport()
        var airports : [Airport] = []
        guard let contentsOfUrl = Bundle.main.url(forResource:"airports", withExtension: "csv") else { return }
        var content = ""
        var error: NSError?
do {
    content = try String(contentsOf: contentsOfUrl, encoding: .utf8)
} catch let error as NSError {
            print("error: \(error)")
}
//        if let content = String(   contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding, error: error) {
            let lines = content.components(separatedBy: .newlines) as [String]
        
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            let scannerString = textScanner.string as String
                            let index = scannerString.index(textScanner.startIndex , offsetBy: 1)
                            if (textScanner.string as String).substring(to: 1)  == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(separater, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value! as String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < count(textScanner.string) {
                                let scannerString = textScanner.string as String
                                let index = scannerString.index(textScanner.scanLocation , offsetBy: 1)
                                textToScan = scannerString.substring(from: index)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the separater (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: separater)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (id: values[0],
                                ident: values[1],
                                type: values[2],
                                name: values[3],
                                latitude_deg: values[4],
                                longitude_deg: values[5],
                                elevation_ft: values[6],
                                continent: values[7],
                                iso_country: values[8],
                                iso_region: values[9],
                                municipality: values[10],
                                scheduled_service: values[11],
                                gps_code: values[12],
                                iata_code: values[13],
                                local_code: values[14],
                                home_link: values[15],
                                wikipedia_link: values[16],
                                keywords: values[17])
                }
            }
//        }
        
    }
    
    func saveAirport(_ values: [String]) {
//        guard let appDelegate = UIApplication.shared.delegate as! AppDelegate else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let airport = Airport(context: context)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func removeAllAirport() {
        
    }

}
