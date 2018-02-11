//  ADSBEchangeRsponse.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//  Swift Models Generated from JSON powered by http://www.json4swift.com


import Foundation
struct ADSBEchangeRsponse : Codable {
	let src : Int?
	let feeds : [Feeds]?
	let srcFeed : Int?
	let showSil : Bool?
	let showFlg : Bool?
	let showPic : Bool?
	let flgH : Int?
	let flgW : Int?
	let acList : [AcList]?
	let totalAc : Int?
	let lastDv : Int?
	let shtTrlSec : Int?
	let stm : Int?

	enum CodingKeys: String, CodingKey {

		case src = "src"
		case feeds = "feeds"
		case srcFeed = "srcFeed"
		case showSil = "showSil"
		case showFlg = "showFlg"
		case showPic = "showPic"
		case flgH = "flgH"
		case flgW = "flgW"
		case acList = "acList"
		case totalAc = "totalAc"
		case lastDv = "lastDv"
		case shtTrlSec = "shtTrlSec"
		case stm = "stm"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		src = try values.decodeIfPresent(Int.self, forKey: .src)
		feeds = try values.decodeIfPresent([Feeds].self, forKey: .feeds)
		srcFeed = try values.decodeIfPresent(Int.self, forKey: .srcFeed)
		showSil = try values.decodeIfPresent(Bool.self, forKey: .showSil)
		showFlg = try values.decodeIfPresent(Bool.self, forKey: .showFlg)
		showPic = try values.decodeIfPresent(Bool.self, forKey: .showPic)
		flgH = try values.decodeIfPresent(Int.self, forKey: .flgH)
		flgW = try values.decodeIfPresent(Int.self, forKey: .flgW)
		acList = try values.decodeIfPresent([AcList].self, forKey: .acList)
		totalAc = try values.decodeIfPresent(Int.self, forKey: .totalAc)
		lastDv = try values.decodeIfPresent(Int.self, forKey: .lastDv)
		shtTrlSec = try values.decodeIfPresent(Int.self, forKey: .shtTrlSec)
		stm = try values.decodeIfPresent(Int.self, forKey: .stm)
	}

}
