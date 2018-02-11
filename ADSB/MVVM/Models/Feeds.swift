//  Feeds.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 11/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//  Swift Models Generated from JSON powered by http://www.json4swift.com

import Foundation
struct Feeds : Codable {
	let id : Int?
	let name : String?
	let polarPlot : Bool?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case polarPlot = "polarPlot"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		polarPlot = try values.decodeIfPresent(Bool.self, forKey: .polarPlot)
	}

}
