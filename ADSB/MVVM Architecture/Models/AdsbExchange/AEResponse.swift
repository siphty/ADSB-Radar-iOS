//
//    AEReponse.swift
//
//    Create by Jiang Yi on 12/2/2018
//    Copyright © 2018 Digiflex Pty Ltd. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct AEResponse: Codable {
    
    let ac: [Aircraft]?
    let total: Int?
    let ctime: Date?
    let ptime: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ac = try container.decodeIfPresent([Aircraft].self, forKey: .ac)
        total = try container.decodeIfPresent(Int.self, forKey: .total)
        let cTimeString = try container.decode(Double.self, forKey: .ctime)
        ctime = Date(timeIntervalSince1970: cTimeString)
        ptime = try container.decodeIfPresent(Int.self, forKey: .ptime)
    }
}

