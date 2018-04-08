//
//    AEReponse.swift
//
//    Create by Jiang Yi on 12/2/2018
//    Copyright © 2018 Digiflex Pty Ltd. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct AEResponse : Codable {
    
    let acList : [Aircraft]?
    let feeds : [Feed]?
    let flgH : Int?
    let flgW : Int?
    let lastDv : String?
    let showFlg : Bool?
    let showPic : Bool?
    let showSil : Bool?
    let shtTrlSec : Int?
    let src : Int?
    let srcFeed : Int?
    let stm : Int?
    let totalAc : Int?
    
    enum CodingKeys: String, CodingKey {
        case acList = "acList"
        case feeds = "feeds"
        case flgH = "flgH"
        case flgW = "flgW"
        case lastDv = "lastDv"
        case showFlg = "showFlg"
        case showPic = "showPic"
        case showSil = "showSil"
        case shtTrlSec = "shtTrlSec"
        case src = "src"
        case srcFeed = "srcFeed"
        case stm = "stm"
        case totalAc = "totalAc"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acList = try values.decodeIfPresent([Aircraft].self, forKey: .acList)
        feeds = try values.decodeIfPresent([Feed].self, forKey: .feeds)
        flgH = try values.decodeIfPresent(Int.self, forKey: .flgH)
        flgW = try values.decodeIfPresent(Int.self, forKey: .flgW)
        lastDv = try values.decodeIfPresent(String.self, forKey: .lastDv)
        showFlg = try values.decodeIfPresent(Bool.self, forKey: .showFlg)
        showPic = try values.decodeIfPresent(Bool.self, forKey: .showPic)
        showSil = try values.decodeIfPresent(Bool.self, forKey: .showSil)
        shtTrlSec = try values.decodeIfPresent(Int.self, forKey: .shtTrlSec)
        src = try values.decodeIfPresent(Int.self, forKey: .src)
        srcFeed = try values.decodeIfPresent(Int.self, forKey: .srcFeed)
        stm = try values.decodeIfPresent(Int.self, forKey: .stm)
        totalAc = try values.decodeIfPresent(Int.self, forKey: .totalAc)
    }
}

