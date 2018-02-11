//  AcList.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//  Swift Models Generated from JSON powered by http://www.json4swift.com

import Foundation
struct AcList : Codable {
	let aircraftId : Int?       //The unique identifier of the aircraft.
	let receiverId : Int?       //The ID of the feed that last supplied information about the aircraft.
	let hasSignalLevel : Bool?  //True if the aircraft has a signal level associated with it.
	let icaoId : String?        //The ICAO of the aircraft.
	let isNotIcao : Bool?       //True if the ICAO is known to be invalid. This information comes from the local BaseStation.sqb database.
	let registration : String?  //The registration.
	let fSeen : String?         //⚠️New key
	let trackedSec : Int?       //The number of seconds that the aircraft has been tracked for.
	let messagesCount : Int?    //The count of messages received for the aircraft.
	let presAltitude : Int?     //The altitude in feet at standard pressure.
	let gndPresAltitude : Int?  //The altitude adjusted for local air pressure, should be roughly the height above mean sea level.
	let presInHg : Double?      //The air pressure in inches of mercury that was used to calculate the AMSL altitude from the standard pressure altitude.
	let altitudeType : Int?     //The type of altitude transmitted by the aircraft: 0 = standard pressure altitude, 1 = indicated altitude (above mean sea level). Default to standard pressure altitude until told otherwise.
	let callsign : String?      //The callsign.
	let latitude : Double?      //The aircraft's latitude over the ground.
	let longitude : Double?     //The aircraft's longitude over the ground.
	let lastPosTime : Int?      //The time (at UTC in JavaScript ticks) that the position was last reported by the aircraft.
	let isFoundByMLAT : Bool?   //True if the latitude and longitude appear to have been calculated by an MLAT server and were not transmitted by the aircraft.
	let isTISBSource : Bool?    //True if the last message received for the aircraft was from a TIS-B source.
	let groundSpeed : Int?      //The ground speed in Knots.
	let trackHeading : Double?  //Aircraft's track angle across the ground clockwise from 0° north.
	let trackIsHeading : Bool?  //True if Trak is the aircraft's heading, false if it's the ground track. Default to ground track until told otherwise.
	let acICAOType : String?    //The aircraft model's ICAO type code.
	let aircraftModel : String? //A description of the aircraft's model. Usually also includes the manufacturer's name.
	let manufacture : String?   //The manufacturer's name.
	let aircraftSN : String?    //The aircraft's construction or serial number.
	let acOperator : String?    //The name of the aircraft's operator.
	let squawkId : Int?         //The squawk as a decimal number
	let isEmergency : Bool?     //True if the aircraft is transmitting an emergency squawk.
	let vertiSpeedType : Int?   //0 = vertical speed is barometric, 1 = vertical speed is geometric. Default to barometric until told otherwise.
    let viewerDistance : Double?//The distance to the aircraft in kilometres.
	let viewerBearing : Double? //The bearing from the browser to the aircraft clockwise from 0° north.
	let wTC : Int?              //The wake turbulence category of the aircraft - see enums.js for values.
	let aircraftSpecies : Int?  //The species of the aircraft
	let engineCount : Int?      //The number of engines the aircraft has.
	let engineType : Int?       //The type of engine the aircraft uses
	let engineMount : Int?      //The placement of engines on the aircraft
	let isMilitary : Bool?      //True if the aircraft appears to be operated by the military.
	let regCountry : String?    //The country that the aircraft is registered to.
	let regCountry : Bool?      //True if the aircraft has a picture associated with it.
	let isInterested : Bool?    //True if the aircraft is flagged as interesting in the BaseStation.sqb local database.
	let flightsCount : Int?     //The number of Flights records the aircraft has in the database.
	let isOnGround : Bool?      //True if the aircraft is on the ground.
	let speedType : Int?        //The type of speed that Spd represents. Only used with raw feeds. 0/missing = ground speed, 1 = ground speed reversing, 2 = indicated air speed, 3 = true air speed.
	let isCallsignUnsure : Bool?//True if the callsign may not be correct.
	let transponderType : Int?  //Transponder type - 0=Unknown, 1=Mode-S, 2=ADS-B (unknown version), 3=ADS-B 0, 4=ADS-B 1, 5=ADS-B 2.
	let yearOfManuf : Int?      //The year that the aircraft was manufactured.

	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case rcvr = "Rcvr"
		case hasSig = "HasSig"
		case icao = "Icao"
		case bad = "Bad"
		case reg = "Reg"
		case fSeen = "FSeen"
		case tSecs = "TSecs"
		case cMsgs = "CMsgs"
		case alt = "Alt"
		case gAlt = "GAlt"
		case inHg = "InHg"
		case altT = "AltT"
		case call = "Call"
		case lat = "Lat"
		case long = "Long"
		case posTime = "PosTime"
		case mlat = "Mlat"
		case tisb = "Tisb"
		case spd = "Spd"
		case trak = "Trak"
		case trkH = "TrkH"
		case type = "Type"
		case mdl = "Mdl"
		case man = "Man"
		case cNum = "CNum"
		case op = "Op"
		case sqk = "Sqk"
		case help = "Help"
		case vsiT = "VsiT"
		case dst = "Dst"
		case brng = "Brng"
		case wTC = "WTC"
		case species = "Species"
		case engines = "Engines"
		case engType = "EngType"
		case engMount = "EngMount"
		case mil = "Mil"
		case cou = "Cou"
		case hasPic = "HasPic"
		case interested = "Interested"
		case flightsCount = "FlightsCount"
		case gnd = "Gnd"
		case spdTyp = "SpdTyp"
		case callSus = "CallSus"
		case trt = "Trt"
		case year = "Year"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		aircraftId = try values.decodeIfPresent(Int.self, forKey: .Id)
		receiverId = try values.decodeIfPresent(Int.self, forKey: .Rcvr)
		hasSignalLevel = try values.decodeIfPresent(Bool.self, forKey: .HasSig)
		icaoId = try values.decodeIfPresent(String.self, forKey: .Icao)
		isNotIcao = try values.decodeIfPresent(Bool.self, forKey: .Bad)
		registration = try values.decodeIfPresent(String.self, forKey: .Reg)
		fSeen = try values.decodeIfPresent(String.self, forKey: .FSeen)
		trackedSec = try values.decodeIfPresent(Int.self, forKey: .TSecs)
		messagesCount = try values.decodeIfPresent(Int.self, forKey: .CMsgs)
		presAltitude = try values.decodeIfPresent(Int.self, forKey: .Alt)
		gndPresAltitude = try values.decodeIfPresent(Int.self, forKey: .GAlt)
		presInHg = try values.decodeIfPresent(Double.self, forKey: .InHg)
		altitudeType = try values.decodeIfPresent(Int.self, forKey: .AltT)
		callsign = try values.decodeIfPresent(String.self, forKey: .Call)
		latitude = try values.decodeIfPresent(Double.self, forKey: .Lat)
		longitude = try values.decodeIfPresent(Double.self, forKey: .Long)
		lastPosTime = try values.decodeIfPresent(Int.self, forKey: .PosTime)
		isFoundByMLAT = try values.decodeIfPresent(Bool.self, forKey: .Mlat)
		isTISBSource = try values.decodeIfPresent(Bool.self, forKey: .Tisb)
		groundSpeed = try values.decodeIfPresent(Int.self, forKey: .Spd)
		trackHeading = try values.decodeIfPresent(Double.self, forKey: .Trak)
		trkH = try values.decodeIfPresent(Bool.self, forKey: .TrkH)
		acICAOType = try values.decodeIfPresent(String.self, forKey: .Type)
		aircraftModel = try values.decodeIfPresent(String.self, forKey: .Mdl)
		manufacture = try values.decodeIfPresent(String.self, forKey: .Man)
		aircraftSN = try values.decodeIfPresent(String.self, forKey: .CNum)
		acOperator = try values.decodeIfPresent(String.self, forKey: .Op)
		squawkId = try values.decodeIfPresent(Int.self, forKey: .Sqk)
		isEmergency = try values.decodeIfPresent(Bool.self, forKey: .Help)
		vsiT = try values.decodeIfPresent(Int.self, forKey: .VsiT)
		viewerDistance = try values.decodeIfPresent(Double.self, forKey: .Dst)
		viewerBearing = try values.decodeIfPresent(Double.self, forKey: .Brng)
		wTC = try values.decodeIfPresent(Int.self, forKey: .WTC)
		aircraftSpecies = try values.decodeIfPresent(Int.self, forKey: .Species)
		engineCount = try values.decodeIfPresent(Int.self, forKey: .Engines)
		engineType = try values.decodeIfPresent(Int.self, forKey: .EngType)
		engineMount = try values.decodeIfPresent(Int.self, forKey: .EngMount)
		isMilitary = try values.decodeIfPresent(Bool.self, forKey: .Mil)
		regCountry = try values.decodeIfPresent(String.self, forKey: .Cou)
		hasPicture = try values.decodeIfPresent(Bool.self, forKey: .HasPic)
		interested = try values.decodeIfPresent(Bool.self, forKey: .Interested)
		flightsCount = try values.decodeIfPresent(Int.self, forKey: .FlightsCount)
		isOnGround = try values.decodeIfPresent(Bool.self, forKey: .Gnd)
		speedType = try values.decodeIfPresent(Int.self, forKey: .SpdTyp)
		isCallsignUnsure = try values.decodeIfPresent(Bool.self, forKey: .CallSus)
		transponderType = try values.decodeIfPresent(Int.self, forKey: .Trt)
		yearOfManuf = try values.decodeIfPresent(Int.self, forKey: .Year)
	}

}
