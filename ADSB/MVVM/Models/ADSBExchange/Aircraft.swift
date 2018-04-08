//  AcList.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Aircraft : Codable {
    
    let presAltitude  : Int?
    let altitudeType : Int?
    let isNotIcao : Bool?
    let messagesCount : Int?
    let aircraftSN : String?
    let callsign : String?
    let isCallsignUnsure : Bool?
    let registerCountry : String?
    let engineMount : Int?
    let engType : Int?
    let engineCount : String?
    let fSeen : String?
    let flightsCount : Int?
    let from : String?
    let groundAltitude : Int?
    let isOnGround : Bool?
    let hasPicture : Bool?
    let hasSignalLevel : Bool?
    let help : Bool?
    let icaoId : String?
    let aircraftId : Int?
    let presInHg : Float?
    let interested : Bool?
    let latitude : Float?
    let longitude : Float?
    let manufacture : String?
    let aircraftModel : String?
    let isMilitary : Bool?
    let isFoundByMLAT : Bool?
    let aircraftOperator : String?
    let acOperatorICAO : String?
    let lastPosTime : Int?
    let receiverId : Int?
    let registration : String?
    let sat : Bool?
    let groundSpeed : Float?
    let speedType : Int?
    let species : Int?
    let squawkId : String?
    let routeStops : [String]?
    let targetAltitude : Int?
    let trackedSec : Int?
    let targetTrack : Float?
    let isTISBSource : Bool?
    let to : String?
    let trackHeading : Float?
    let trackIsHeading : Bool?
    let transponderType : Int?
    let aircraftICAOType : String?
    let vertiSpeed : Int?
    let vertiSpeedType : Int?
    let wTC : Int?
    let yearOfManuf : String?
    
    enum CodingKeys: String, CodingKey {
        case presAltitude  = "Alt"
        case altitudeType = "AltT"
        case isNotIcao = "Bad"
        case messagesCount = "CMsgs"
        case aircraftSN = "CNum"
        case callsign = "Call"
        case isCallsignUnsure = "CallSus"
        case registerCountry = "Cou"
        case engineMount = "EngMount"
        case engType = "EngType"
        case engineCount = "Engines"
        case fSeen = "FSeen"
        case flightsCount = "FlightsCount"
        case from = "From"
        case groundAltitude = "GAlt"
        case isOnGround = "Gnd"
        case hasPicture = "HasPic"
        case hasSignalLevel = "HasSig"
        case help = "Help"
        case icaoId = "Icao"
        case aircraftId = "Id"
        case presInHg = "InHg"
        case interested = "Interested"
        case latitude = "Lat"
        case longitude = "Long"
        case manufacture = "Man"
        case aircraftModel = "Mdl"
        case isMilitary = "Mil"
        case isFoundByMLAT = "Mlat"
        case aircraftOperator = "Op"
        case acOperatorICAO = "OpIcao"
        case lastPosTime = "PosTime"
        case receiverId = "Rcvr"
        case registration = "Reg"
        case sat = "Sat"
        case groundSpeed = "Spd"
        case speedType = "SpdTyp"
        case species = "Species"
        case squawkId = "Sqk"
        case routeStops = "Stops"
        case targetAltitude = "TAlt"
        case trackedSec = "TSecs"
        case targetTrack = "TTrk"
        case isTISBSource = "Tisb"
        case to = "To"
        case trackHeading = "Trak"
        case trackIsHeading = "TrkH"
        case transponderType = "Trt"
        case aircraftICAOType = "Type"
        case vertiSpeed = "Vsi"
        case vertiSpeedType = "VsiT"
        case wTC = "WTC"
        case yearOfManuf = "Year"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        presAltitude  = try values.decodeIfPresent(Int.self, forKey: .presAltitude )
        altitudeType = try values.decodeIfPresent(Int.self, forKey: .altitudeType)
        isNotIcao = try values.decodeIfPresent(Bool.self, forKey: .isNotIcao)
        messagesCount = try values.decodeIfPresent(Int.self, forKey: .messagesCount)
        aircraftSN = try values.decodeIfPresent(String.self, forKey: .aircraftSN)
        callsign = try values.decodeIfPresent(String.self, forKey: .callsign)
        isCallsignUnsure = try values.decodeIfPresent(Bool.self, forKey: .isCallsignUnsure)
        registerCountry = try values.decodeIfPresent(String.self, forKey: .registerCountry)
        engineMount = try values.decodeIfPresent(Int.self, forKey: .engineMount)
        engType = try values.decodeIfPresent(Int.self, forKey: .engType)
        engineCount = try values.decodeIfPresent(String.self, forKey: .engineCount)
        fSeen = try values.decodeIfPresent(String.self, forKey: .fSeen)
        flightsCount = try values.decodeIfPresent(Int.self, forKey: .flightsCount)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        groundAltitude = try values.decodeIfPresent(Int.self, forKey: .groundAltitude)
        isOnGround = try values.decodeIfPresent(Bool.self, forKey: .isOnGround)
        hasPicture = try values.decodeIfPresent(Bool.self, forKey: .hasPicture)
        hasSignalLevel = try values.decodeIfPresent(Bool.self, forKey: .hasSignalLevel)
        help = try values.decodeIfPresent(Bool.self, forKey: .help)
        icaoId = try values.decodeIfPresent(String.self, forKey: .icaoId)
        aircraftId = try values.decodeIfPresent(Int.self, forKey: .aircraftId)
        presInHg = try values.decodeIfPresent(Float.self, forKey: .presInHg)
        interested = try values.decodeIfPresent(Bool.self, forKey: .interested)
        latitude = try values.decodeIfPresent(Float.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Float.self, forKey: .longitude)
        manufacture = try values.decodeIfPresent(String.self, forKey: .manufacture)
        aircraftModel = try values.decodeIfPresent(String.self, forKey: .aircraftModel)
        isMilitary = try values.decodeIfPresent(Bool.self, forKey: .isMilitary)
        isFoundByMLAT = try values.decodeIfPresent(Bool.self, forKey: .isFoundByMLAT)
        aircraftOperator = try values.decodeIfPresent(String.self, forKey: .aircraftOperator)
        acOperatorICAO = try values.decodeIfPresent(String.self, forKey: .acOperatorICAO)
        lastPosTime = try values.decodeIfPresent(Int.self, forKey: .lastPosTime)
        receiverId = try values.decodeIfPresent(Int.self, forKey: .receiverId)
        registration = try values.decodeIfPresent(String.self, forKey: .registration)
        sat = try values.decodeIfPresent(Bool.self, forKey: .sat)
        groundSpeed = try values.decodeIfPresent(Float.self, forKey: .groundSpeed)
        speedType = try values.decodeIfPresent(Int.self, forKey: .speedType)
        species = try values.decodeIfPresent(Int.self, forKey: .species)
        squawkId = try values.decodeIfPresent(String.self, forKey: .squawkId)
        routeStops = try values.decodeIfPresent([String].self, forKey: .routeStops)
        targetAltitude = try values.decodeIfPresent(Int.self, forKey: .targetAltitude)
        trackedSec = try values.decodeIfPresent(Int.self, forKey: .trackedSec)
        targetTrack = try values.decodeIfPresent(Float.self, forKey: .targetTrack)
        isTISBSource = try values.decodeIfPresent(Bool.self, forKey: .isTISBSource)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        trackHeading = try values.decodeIfPresent(Float.self, forKey: .trackHeading)
        trackIsHeading = try values.decodeIfPresent(Bool.self, forKey: .trackIsHeading)
        transponderType = try values.decodeIfPresent(Int.self, forKey: .transponderType)
        aircraftICAOType = try values.decodeIfPresent(String.self, forKey: .aircraftICAOType)
        vertiSpeed = try values.decodeIfPresent(Int.self, forKey: .vertiSpeed)
        vertiSpeedType = try values.decodeIfPresent(Int.self, forKey: .vertiSpeedType)
        wTC = try values.decodeIfPresent(Int.self, forKey: .wTC)
        yearOfManuf = try values.decodeIfPresent(String.self, forKey: .yearOfManuf)
    }
    
}
