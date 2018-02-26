//  AcList.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper
class Aircraft : NSObject, NSCoding, Mappable{
	var aircraftId : Int?       //The unique identifier of the aircraft.
	var receiverId : Int?       //The ID of the feed that last supplied information about the aircraft.
	var hasSignalLevel : Bool?  //True if the aircraft has a signal level associated with it.
    var signalLevel : Int?
	var icaoId : String?        //The ICAO of the aircraft.
	var isNotIcao : Bool?       //True if the ICAO is known to be invalid. This information comes from the local BaseStation.sqb database.
	var registration : String?  //The registration.
	var fSeen : String?         //⚠️New key
	var trackedSec : Int?       //The number of seconds that the aircraft has been tracked for.
	var messagesCount : Int?    //The count of messages received for the aircraft.
	var presAltitude : Int?     //The altitude in feet at standard pressure.
	var groundAltitude : Int?  //The altitude adjusted for local air pressure, should be roughly the height above mean sea level.
	var presInHg : Float?      //The air pressure in inches of mercury that was used to calculate the AMSL altitude from the standard pressure altitude.
	var altitudeType : Int?     //The type of altitude transmitted by the aircraft: 0 = standard pressure altitude, 1 = indicated altitude (above mean sea level). Default to standard pressure altitude until told otherwise.
	var callsign : String?      //The callsign.
	var latitude : Float?      //The aircraft's latitude over the ground.
	var longitude : Float?     //The aircraft's longitude over the ground.
	var lastPosTime : Int?      //The time (at UTC in JavaScript ticks) that the position was last reported by the aircraft.
	var isFoundByMLAT : Bool?   //True if the latitude and longitude appear to have been calculated by an MLAT server and were not transmitted by the aircraft.
	var isTISBSource : Bool?    //True if the last message received for the aircraft was from a TIS-B source.
	var groundSpeed : Double?      //The ground speed in Knots.
	var trackHeading : Float?  //Aircraft's track angle across the ground clockwise from 0° north.
	var trackIsHeading : Bool?  //True if Trak is the aircraft's heading, false if it's the ground track. Default to ground track until told otherwise.
	var aICAOType : String?    //The aircraft model's ICAO type code.
	var aircraftModel : String? //A description of the aircraft's model. Usually also includes the manufacturer's name.
	var manufacture : String?   //The manufacturer's name.
	var aircraftSN : String?    //The aircraft's construction or serial number.
	var aircraftOperator : String?    //The name of the aircraft's operator.
	var squawkId : String?         //The squawk as a decimal number
	var isEmergency : Bool?     //True if the aircraft is transmitting an emergency squawk.
	var vertiSpeedType : Int?   //0 = vertical speed is barometric, 1 = vertical speed is geometric. Default to barometric until told otherwise.
    var viewerDistance : Float?//The distance to the aircraft in kilometres.
	var viewerBearing : Float? //The bearing from the browser to the aircraft clockwise from 0° north.
	var wTC : Int?              //The wake turbulence category of the aircraft - see enums.js for values.
	var aircraftSpecies : Int?  //The species of the aircraft
	var engineCount : String?      //The number of engines the aircraft has.
	var engineType : Int?       //The type of engine the aircraft uses
	var engineMount : Int?      //The placement of engines on the aircraft
	var isMilitary : Bool?      //True if the aircraft appears to be operated by the military.
	var regCountry : String?    //The country that the aircraft is registered to.
	var hasPicture : Bool?      //True if the aircraft has a picture associated with it.
	var isInterested : Bool?    //True if the aircraft is flagged as interesting in the BaseStation.sqb local database.
	var flightsCount : Int?     //The number of Flights records the aircraft has in the database.
	var isOnGround : Bool?      //True if the aircraft is on the ground.
	var speedType : Int?        //The type of speed that Spd represents. Only used with raw feeds.
                                //0 = missing ground speed,
                                //1 = ground speed reversing,
                                //2 = indicated air speed,
                                //3 = true air speed.
	var isCallsignUnsure : Bool?//True if the callsign may not be correct.
    var transponderType : Int?  //Transponder type :
                                //0=Unknown,
                                //1=Mode-S,
                                //2=ADS-B (unknown version),
                                //3=ADS-B 0,
                                //4=ADS-B 1,
                                //5=ADS-B 2.
	var yearOfManuf : String?   //The year that the aircraft was manufactured.
    var from : String?          //The code and name of the departure airport.
    var to : String?            //The code and name of the destination airport.
    var acOperatorICAO : String?//The operator's ICAO code.
    var routeStops : [String]?  //An array of strings, each being a stopover on the route.
    var picX : Int?             //The width of the picture in pixels.
    var picY : Int?             //The height of the picture in pixels.
    var isPositionOld : Bool?   //True if the last position update is older than the display timeout value - usually only seen on MLAT aircraft in merged feeds.
    var targetAltitude : Int?   //The target altitude, in feet, set on the autopilot / FMS etc.
    var targetHeading : String? //The track or heading currently set on the aircraft's autopilot or FMS.
    var aircraftICAOType: String?//The aircraft model's ICAO type code.
    var targetTrack : Float?    //The track or heading currently set on the aircraft's autopilot or FMS.
    var aircraftUserTag : String?      //The user tag found for the aircraft in the BaseStation.sqb local database.
    var vertiSpeed : Int?      //Vertical speed in Feet per Minute.
    
    class func newInstance(map: Map) -> Mappable?{
        return Aircraft()
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        presAltitude <- map["Alt"]
        altitudeType <- map["AltT"]
        isNotIcao <- map["Bad"]
        viewerBearing <- map["Brng"]
        messagesCount <- map["CMsgs"]
        aircraftSN <- map["CNum"]
        callsign <- map["Call"]
        isCallsignUnsure <- map["CallSus"]
        regCountry <- map["Cou"]
        viewerDistance <- map["Dst"]
        engineMount <- map["EngMount"]
        engineType <- map["EngType"]
        engineCount <- map["Engines"]
        fSeen <- map["FSeen"]
        flightsCount <- map["FlightsCount"]
        from <- map["From"]
        to <- map["To"]
        groundAltitude <- map["GAlt"]
        isOnGround <- map["Gnd"]
        hasPicture <- map["HasPic"]
        hasSignalLevel <- map["HasSig"]
        isEmergency <- map["Help"]
        icaoId <- map["Icao"]
        aircraftId <- map["Id"]
        presInHg <- map["InHg"]
        isInterested <- map["Interested"]
        latitude <- map["Lat"]
        longitude <- map["Long"]
        manufacture <- map["Man"]
        aircraftModel <- map["Mdl"]
        isMilitary <- map["Mil"]
        isFoundByMLAT <- map["Mlat"]
        aircraftOperator <- map["Op"]
        acOperatorICAO <- map["OpIcao"]
        picX <- map["PicX"]
        picY <- map["PicY"]
        isPositionOld <- map["PosStale"]
        lastPosTime <- map["PosTime"]
        receiverId <- map["Rcvr"]
        registration <- map["Reg"]
        signalLevel <- map["Sig"]
        groundSpeed <- map["Spd"]
        speedType <- map["SpdTyp"]
        aircraftSpecies <- map["Species"]
        squawkId <- map["Sqk"]
        routeStops <- map["Stops"]
        targetAltitude <- map["TAlt"]
        trackedSec <- map["TSecs"]
        targetTrack <- map["TTrk"]
        aircraftUserTag <- map["Tag"]
        isTISBSource <- map["Tisb"]
        trackHeading <- map["Trak"]
        trackIsHeading <- map["TrkH"]
        transponderType <- map["Trt"]
        aircraftICAOType <- map["Type"]
        vertiSpeed <- map["Vsi"]
        vertiSpeedType <- map["VsiT"]
        wTC <- map["WTC"]
        yearOfManuf <- map["Year"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        presAltitude = aDecoder.decodeObject(forKey: "Alt") as? Int
        altitudeType = aDecoder.decodeObject(forKey: "AltT") as? Int
        isNotIcao = aDecoder.decodeObject(forKey: "Bad") as? Bool
        viewerBearing = aDecoder.decodeObject(forKey: "Brng") as? Float
        messagesCount = aDecoder.decodeObject(forKey: "CMsgs") as? Int
        aircraftSN = aDecoder.decodeObject(forKey: "CNum") as? String
        callsign = aDecoder.decodeObject(forKey: "Call") as? String
        isCallsignUnsure = aDecoder.decodeObject(forKey: "CallSus") as? Bool
        regCountry = aDecoder.decodeObject(forKey: "Cou") as? String
        viewerDistance = aDecoder.decodeObject(forKey: "Dst") as? Float
        engineMount = aDecoder.decodeObject(forKey: "EngMount") as? Int
        engineType = aDecoder.decodeObject(forKey: "EngType") as? Int
        engineCount = aDecoder.decodeObject(forKey: "Engines") as? String
        fSeen = aDecoder.decodeObject(forKey: "FSeen") as? String
        flightsCount = aDecoder.decodeObject(forKey: "FlightsCount") as? Int
        from = aDecoder.decodeObject(forKey: "From") as? String
        groundAltitude = aDecoder.decodeObject(forKey: "GAlt") as? Int
        isOnGround = aDecoder.decodeObject(forKey: "Gnd") as? Bool
        hasPicture = aDecoder.decodeObject(forKey: "HasPic") as? Bool
        hasSignalLevel = aDecoder.decodeObject(forKey: "HasSig") as? Bool
        isEmergency = aDecoder.decodeObject(forKey: "Help") as? Bool
        icaoId = aDecoder.decodeObject(forKey: "Icao") as? String
        aircraftId = aDecoder.decodeObject(forKey: "Id") as? Int
        presInHg = aDecoder.decodeObject(forKey: "InHg") as? Float
        isInterested = aDecoder.decodeObject(forKey: "Interested") as? Bool
        latitude = aDecoder.decodeObject(forKey: "Lat") as? Float
        longitude = aDecoder.decodeObject(forKey: "Long") as? Float
        manufacture = aDecoder.decodeObject(forKey: "Man") as? String
        aircraftModel = aDecoder.decodeObject(forKey: "Mdl") as? String
        isMilitary = aDecoder.decodeObject(forKey: "Mil") as? Bool
        isFoundByMLAT = aDecoder.decodeObject(forKey: "Mlat") as? Bool
        aircraftOperator = aDecoder.decodeObject(forKey: "Op") as? String
        acOperatorICAO = aDecoder.decodeObject(forKey: "OpIcao") as? String
        picX = aDecoder.decodeObject(forKey: "PicX") as? Int
        picY = aDecoder.decodeObject(forKey: "PicY") as? Int
        isPositionOld = aDecoder.decodeObject(forKey: "PosStale") as? Bool
        lastPosTime = aDecoder.decodeObject(forKey: "PosTime") as? Int
        receiverId = aDecoder.decodeObject(forKey: "Rcvr") as? Int
        registration = aDecoder.decodeObject(forKey: "Reg") as? String
        signalLevel = aDecoder.decodeObject(forKey: "Sig") as? Int
        groundSpeed = aDecoder.decodeObject(forKey: "Spd") as? Double
        speedType = aDecoder.decodeObject(forKey: "SpdTyp") as? Int
        aircraftSpecies = aDecoder.decodeObject(forKey: "Species") as? Int
        squawkId = aDecoder.decodeObject(forKey: "Sqk") as? String
        routeStops = aDecoder.decodeObject(forKey: "Stops") as? [String]
        targetAltitude = aDecoder.decodeObject(forKey: "TAlt") as? Int
        trackedSec = aDecoder.decodeObject(forKey: "TSecs") as? Int
        targetTrack = aDecoder.decodeObject(forKey: "TTrk") as? Float
        aircraftUserTag = aDecoder.decodeObject(forKey: "Tag") as? String
        isTISBSource = aDecoder.decodeObject(forKey: "Tisb") as? Bool
        to = aDecoder.decodeObject(forKey: "To") as? String
        trackHeading = aDecoder.decodeObject(forKey: "Trak") as? Float
        trackIsHeading = aDecoder.decodeObject(forKey: "TrkH") as? Bool
        transponderType = aDecoder.decodeObject(forKey: "Trt") as? Int
        aircraftICAOType = aDecoder.decodeObject(forKey: "Type") as? String
        vertiSpeed = aDecoder.decodeObject(forKey: "Vsi") as? Int
        vertiSpeedType = aDecoder.decodeObject(forKey: "VsiT") as? Int
        wTC = aDecoder.decodeObject(forKey: "WTC") as? Int
        yearOfManuf = aDecoder.decodeObject(forKey: "Year") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if presAltitude != nil{
            aCoder.encode(presAltitude, forKey: "Alt")
        }
        if altitudeType != nil{
            aCoder.encode(altitudeType, forKey: "AltT")
        }
        if isNotIcao != nil{
            aCoder.encode(isNotIcao, forKey: "Bad")
        }
        if viewerBearing != nil{
            aCoder.encode(viewerBearing, forKey: "Brng")
        }
        if messagesCount != nil{
            aCoder.encode(messagesCount, forKey: "CMsgs")
        }
        if aircraftSN != nil{
            aCoder.encode(aircraftSN, forKey: "CNum")
        }
        if callsign != nil{
            aCoder.encode(callsign, forKey: "Call")
        }
        if isCallsignUnsure != nil{
            aCoder.encode(isCallsignUnsure, forKey: "CallSus")
        }
        if regCountry != nil{
            aCoder.encode(regCountry, forKey: "Cou")
        }
        if viewerDistance != nil{
            aCoder.encode(viewerDistance, forKey: "Dst")
        }
        if engineMount != nil{
            aCoder.encode(engineMount, forKey: "EngMount")
        }
        if engineType != nil{
            aCoder.encode(engineType, forKey: "EngType")
        }
        if engineCount != nil{
            aCoder.encode(engineCount, forKey: "Engines")
        }
        if fSeen != nil{
            aCoder.encode(fSeen, forKey: "FSeen")
        }
        if flightsCount != nil{
            aCoder.encode(flightsCount, forKey: "FlightsCount")
        }
        if from != nil{
            aCoder.encode(from, forKey: "From")
        }
        if groundAltitude != nil{
            aCoder.encode(groundAltitude, forKey: "GAlt")
        }
        if isOnGround != nil{
            aCoder.encode(isOnGround, forKey: "Gnd")
        }
        if hasPicture != nil{
            aCoder.encode(hasPicture, forKey: "HasPic")
        }
        if hasSignalLevel != nil{
            aCoder.encode(hasSignalLevel, forKey: "HasSig")
        }
        if isEmergency != nil{
            aCoder.encode(isEmergency, forKey: "Help")
        }
        if icaoId != nil{
            aCoder.encode(icaoId, forKey: "Icao")
        }
        if aircraftId != nil{
            aCoder.encode(aircraftId, forKey: "Id")
        }
        if presInHg != nil{
            aCoder.encode(presInHg, forKey: "InHg")
        }
        if isInterested != nil{
            aCoder.encode(isInterested, forKey: "Interested")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "Lat")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "Long")
        }
        if manufacture != nil{
            aCoder.encode(manufacture, forKey: "Man")
        }
        if aircraftModel != nil{
            aCoder.encode(aircraftModel, forKey: "Mdl")
        }
        if isMilitary != nil{
            aCoder.encode(isMilitary, forKey: "Mil")
        }
        if isFoundByMLAT != nil{
            aCoder.encode(isFoundByMLAT, forKey: "Mlat")
        }
        if aircraftOperator != nil{
            aCoder.encode(aircraftOperator, forKey: "Op")
        }
        if acOperatorICAO != nil{
            aCoder.encode(acOperatorICAO, forKey: "OpIcao")
        }
        if picX != nil{
            aCoder.encode(picX, forKey: "PicX")
        }
        if picY != nil{
            aCoder.encode(picY, forKey: "PicY")
        }
        if isPositionOld != nil{
            aCoder.encode(isPositionOld, forKey: "PosStale")
        }
        if lastPosTime != nil{
            aCoder.encode(lastPosTime, forKey: "PosTime")
        }
        if receiverId != nil{
            aCoder.encode(receiverId, forKey: "Rcvr")
        }
        if registration != nil{
            aCoder.encode(registration, forKey: "Reg")
        }
        if signalLevel != nil{
            aCoder.encode(signalLevel, forKey: "Sig")
        }
        if groundSpeed != nil{
            aCoder.encode(groundSpeed, forKey: "Spd")
        }
        if speedType != nil{
            aCoder.encode(speedType, forKey: "SpdTyp")
        }
        if aircraftSpecies != nil{
            aCoder.encode(aircraftSpecies, forKey: "Species")
        }
        if squawkId != nil{
            aCoder.encode(squawkId, forKey: "Sqk")
        }
        if routeStops != nil{
            aCoder.encode(routeStops, forKey: "Stops")
        }
        if targetAltitude != nil{
            aCoder.encode(targetAltitude, forKey: "TAlt")
        }
        if trackedSec != nil{
            aCoder.encode(trackedSec, forKey: "TSecs")
        }
        if targetTrack != nil{
            aCoder.encode(targetTrack, forKey: "TTrk")
        }
        if aircraftUserTag != nil{
            aCoder.encode(aircraftUserTag, forKey: "Tag")
        }
        if isTISBSource != nil{
            aCoder.encode(isTISBSource, forKey: "Tisb")
        }
        if to != nil{
            aCoder.encode(to, forKey: "To")
        }
        if trackHeading != nil{
            aCoder.encode(trackHeading, forKey: "Trak")
        }
        if trackHeading != nil{
            aCoder.encode(trackHeading, forKey: "TrkH")
        }
        if transponderType != nil{
            aCoder.encode(transponderType, forKey: "Trt")
        }
        if aircraftICAOType != nil{
            aCoder.encode(aircraftICAOType, forKey: "Type")
        }
        if vertiSpeed != nil{
            aCoder.encode(vertiSpeed, forKey: "Vsi")
        }
        if vertiSpeedType != nil{
            aCoder.encode(vertiSpeedType, forKey: "VsiT")
        }
        if wTC != nil{
            aCoder.encode(wTC, forKey: "WTC")
        }
        if yearOfManuf != nil{
            aCoder.encode(yearOfManuf, forKey: "Year")
        }
        
    }
    
}

