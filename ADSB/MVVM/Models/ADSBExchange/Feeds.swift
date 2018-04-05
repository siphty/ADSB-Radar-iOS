//
//    Feed.swift
//
//    Create by Jiang Yi on 12/2/2018
//    Copyright © 2018 Digiflex Pty Ltd. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Feed : Codable {
    
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
