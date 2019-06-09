//  AcList.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

enum AircraftSpeedType {
    case groundSpeed
    case groundSpeedReversing
    case indicatedAirSpeed
    case trueAirSpeed
}

enum AircraftAltitudeType {
    
}

struct Aircraft: Codable {
    
    let lastPOSTime: Date?
    let icaoID: String?
    let registration: String?
    let aircraftICAOType: String?
    
    // Wake Turbulence category.  Broadcast by the aircraft. 0 = None, 1 = Light, 2 = Medium, 3 = Heavy
    let wtc: Int?
    
    // 0/missing = ground speed, 1 = ground speed reversing, 2 = indicated air speed, 3 = true air speed.
    let speedType: String? 
    let groundSpeed: Float?
    
    // 0 = standard pressure altitude, 1 = indicated altitude (above mean sea level).
    let altitudeType: Int?
    let presAltitude : Int?
    let groundAltitude: Int?
    let targetAltitude: Int?
    let latitude: Float?
    let longitude: Float?
    
    //0 = vertical speed is barometric, 1 = vertical speed is geometric. Default to barometric until told otherwise.
    let vertiSpeedType: Int?
    let vertiSpeed: Int?
    let trackIsHeading: Bool?
    let targetTrack: Float?
    let trackHeading: Float?
    let squawkId: String?
    let callSign: String?
    let isOnGround: Bool?
    
    //Transponder type. 0=Unknown, 1=Mode-S, 2=ADS-B (unknown version), 
    //3=ADS-B 0 – DO-260, 4=ADS-B 1 – DO-260 (A), 5=ADS-B 2 – DO-260 (B)
    let transponderType: Int?
    let pos: String?
    let isFoundByMLAT: Bool?
    let isTISBSource: Bool?
    let sat: Bool?
    let acOperatorICAO: String?
    let registerCountry: String?
    let isMilitary: Bool?
    let interested: Bool?
    let from: String?
    let to: String?
    
    let engineType: Int?
    
    enum CodingKeys: String, CodingKey {
        case lastPOSTime = "postime"
        case icaoID = "icao"
        case registration = "reg"
        case aircraftICAOType = "type"
        case wtc = "wtc"
        case speedType = "spdtyp"
        case groundSpeed = "spd"
        case altitudeType = "altt"
        case presAltitude  = "alt"
        case groundAltitude = "galt"
        case targetAltitude = "talt"
        case latitude = "lat"
        case longitude = "lon"
        case vertiSpeedType = "vsit"
        case vertiSpeed = "vsi"
        case trackIsHeading = "trkh"
        case targetTrack = "ttrk"
        case trackHeading = "trak"
        case squawkId = "sqk"
        case callSign = "call"
        case isOnGround = "gnd"
        case transponderType = "trt"
        case pos = "pos"
        case isFoundByMLAT = "mlat"
        case isTISBSource = "tisb"
        case sat = "sat"
        case acOperatorICAO = "opIcao"
        case registerCountry = "cou"   
        case isMilitary = "mil"   
        case interested = "interested"  
        case from = "from"
        case to = "to"
        
        
        case engineType = "EngType"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lastPOSTimeDouble = Double(try container.decodeIfPresent(String.self, forKey: .lastPOSTime) ?? "0") ?? 0
        lastPOSTime = Date(timeIntervalSince1970: lastPOSTimeDouble)
        icaoID = try container.decodeIfPresent(String.self, forKey: .icaoID)
        registration = try container.decodeIfPresent(String.self, forKey: .registration)
        aircraftICAOType = try container.decodeIfPresent(String.self, forKey: .aircraftICAOType)
        let wtcString = try container.decodeIfPresent(String.self, forKey: .wtc) ?? "0"
        wtc = Int(wtcString) ?? 0
        speedType = try container.decodeIfPresent(String.self, forKey: .speedType)
        let groundSpeedString = try container.decodeIfPresent(String.self, forKey: .groundSpeed) ?? "0"
        groundSpeed = Float(groundSpeedString) ?? 0.0
        let altitudeTypeString = try container.decodeIfPresent(String.self, forKey: .altitudeType) ?? "0"
        altitudeType = Int(altitudeTypeString) ?? 0 
        let presAltitudeString = try container.decodeIfPresent(String.self, forKey: .presAltitude) ?? "0"
        presAltitude = Int(presAltitudeString) ?? 0 
        let groundAltitudeString = try container.decodeIfPresent(String.self, forKey: .groundAltitude) ?? "0"
        groundAltitude = Int(groundAltitudeString) ?? 0 
        let targetAltitudeString = try container.decodeIfPresent(String.self, forKey: .targetAltitude) ?? "0"
        targetAltitude = Int(targetAltitudeString) ?? 0 
        let latitudeString = try container.decodeIfPresent(String.self, forKey: .latitude) ?? "0"
        latitude = Float(latitudeString) ?? 0 
        let longitudeString = try container.decodeIfPresent(String.self, forKey: .longitude) ?? "0"
        longitude = Float(longitudeString) ?? 0 
        let vertiSpeedTypeString = try container.decodeIfPresent(String.self, forKey: .vertiSpeedType) ?? "0"
        vertiSpeedType = Int(vertiSpeedTypeString) ?? 0 
        let vertiSpeedString = try container.decodeIfPresent(String.self, forKey: .vertiSpeed) ?? "0"
        vertiSpeed = Int(vertiSpeedString) ?? 0 
        let trackIsHeadingString = try container.decodeIfPresent(String.self, forKey: .trackIsHeading) ?? "0"
        trackIsHeading = (Int(trackIsHeadingString) ?? 0) > 0 ? true : false
        let targetTrackString = try container.decodeIfPresent(String.self, forKey: .targetTrack) ?? "0"
        targetTrack = Float(targetTrackString) ?? 0 
        let trackHeadingString = try container.decodeIfPresent(String.self, forKey: .trackHeading) ?? "0"
        trackHeading = Float(trackHeadingString) ?? 0 
        squawkId = try container.decodeIfPresent(String.self, forKey: .squawkId)
        callSign = try container.decodeIfPresent(String.self, forKey: .callSign)
        let isOnGroundString = try container.decodeIfPresent(String.self, forKey: .isOnGround) ?? "0"
        isOnGround = (Int(isOnGroundString) ?? 0) > 0 ? true : false
        let transponderTypeString = try container.decodeIfPresent(String.self, forKey: .transponderType) ?? "0"
        transponderType = Int(transponderTypeString) ?? 0 
        pos = try container.decodeIfPresent(String.self, forKey: .pos)
        let isFoundByMLATString = try container.decodeIfPresent(String.self, forKey: .isFoundByMLAT) ?? "0"
        isFoundByMLAT = (Int(isFoundByMLATString) ?? 0) > 0 ? true : false
        let isTISBSourceString = try container.decodeIfPresent(String.self, forKey: .isTISBSource) ?? "0"
        isTISBSource = (Int(isTISBSourceString) ?? 0) > 0 ? true : false
        let satString = try container.decodeIfPresent(String.self, forKey: .sat) ?? "0"
        sat = (Int(satString) ?? 0) > 0 ? true : false
        acOperatorICAO = try container.decodeIfPresent(String.self, forKey: .acOperatorICAO)
        registerCountry = try container.decodeIfPresent(String.self, forKey: .registerCountry)
        let isMilitaryString = try container.decodeIfPresent(String.self, forKey: .isMilitary) ?? "0"
        isMilitary = (Int(isMilitaryString) ?? 0) > 0 ? true : false
        let interestedString = try container.decodeIfPresent(String.self, forKey: .interested) ?? "0"
        interested = (Int(interestedString) ?? 0) > 0 ? true : false
        from = try container.decodeIfPresent(String.self, forKey: .from)
        to = try container.decodeIfPresent(String.self, forKey: .to)
        let engineTypeString = try container.decodeIfPresent(String.self, forKey: .engineType) ?? "0"
        engineType = Int(engineTypeString) ?? 0
    }
        
    
}
