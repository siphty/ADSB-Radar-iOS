//
//  JSONLoader.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 16/2/19.
//  Copyright © 2019 Siphty. All rights reserved.
//

import Foundation

enum BundleFile: String {
    case googleMapStyle1 = "GoogleMapStyle1"
    case googleMapStyle2 = "GoogleMapStyle2"
    case test = "GoogleMapStyleTest"
}



struct JSONLoader {
    
    static func decode<T>(_ type: T.Type, fromFile file: BundleFile) -> T where T: Codable {
        do {
            guard let path = Bundle.main.path(forResource: file.rawValue, ofType: "json") else { 
                fatalError("Failed to access file: \(file)")
            }
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch let error {
            fatalError("Failed to decode \(type) from \(file) with error: \(error.localizedDescription)")
        }
        
    }
    
}


struct CSVLoader {
    
    static func decode<T>(_ type: T.Type, fromFile file: BundleFile) -> T where T: Codable {
        do {
            guard let path = Bundle.main.path(forResource: file.rawValue, ofType: "csv") else { 
                fatalError("Failed to access file: \(file)")
            }
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch let error {
            fatalError("Failed to decode \(type) from \(file) with error: \(error.localizedDescription)")
        }
        
    }
    
}
