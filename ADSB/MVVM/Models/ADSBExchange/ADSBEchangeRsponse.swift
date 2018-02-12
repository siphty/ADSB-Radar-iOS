//
//    RootClass.swift
//
//    Create by Jiang Yi on 12/2/2018
//    Copyright © 2018 Digiflex Pty Ltd. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class AEReponse : NSObject, NSCoding, Mappable{
    
    var acList : [AcList]?
    var feeds : [Feed]?
    var flgH : Int?
    var flgW : Int?
    var lastDv : String?
    var showFlg : Bool?
    var showPic : Bool?
    var showSil : Bool?
    var shtTrlSec : Int?
    var src : Int?
    var srcFeed : Int?
    var stm : Int?
    var totalAc : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return RootClass()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        acList <- map["acList"]
        feeds <- map["feeds"]
        flgH <- map["flgH"]
        flgW <- map["flgW"]
        lastDv <- map["lastDv"]
        showFlg <- map["showFlg"]
        showPic <- map["showPic"]
        showSil <- map["showSil"]
        shtTrlSec <- map["shtTrlSec"]
        src <- map["src"]
        srcFeed <- map["srcFeed"]
        stm <- map["stm"]
        totalAc <- map["totalAc"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        acList = aDecoder.decodeObject(forKey: "acList") as? [AcList]
        feeds = aDecoder.decodeObject(forKey: "feeds") as? [Feed]
        flgH = aDecoder.decodeObject(forKey: "flgH") as? Int
        flgW = aDecoder.decodeObject(forKey: "flgW") as? Int
        lastDv = aDecoder.decodeObject(forKey: "lastDv") as? String
        showFlg = aDecoder.decodeObject(forKey: "showFlg") as? Bool
        showPic = aDecoder.decodeObject(forKey: "showPic") as? Bool
        showSil = aDecoder.decodeObject(forKey: "showSil") as? Bool
        shtTrlSec = aDecoder.decodeObject(forKey: "shtTrlSec") as? Int
        src = aDecoder.decodeObject(forKey: "src") as? Int
        srcFeed = aDecoder.decodeObject(forKey: "srcFeed") as? Int
        stm = aDecoder.decodeObject(forKey: "stm") as? Int
        totalAc = aDecoder.decodeObject(forKey: "totalAc") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if acList != nil{
            aCoder.encode(acList, forKey: "acList")
        }
        if feeds != nil{
            aCoder.encode(feeds, forKey: "feeds")
        }
        if flgH != nil{
            aCoder.encode(flgH, forKey: "flgH")
        }
        if flgW != nil{
            aCoder.encode(flgW, forKey: "flgW")
        }
        if lastDv != nil{
            aCoder.encode(lastDv, forKey: "lastDv")
        }
        if showFlg != nil{
            aCoder.encode(showFlg, forKey: "showFlg")
        }
        if showPic != nil{
            aCoder.encode(showPic, forKey: "showPic")
        }
        if showSil != nil{
            aCoder.encode(showSil, forKey: "showSil")
        }
        if shtTrlSec != nil{
            aCoder.encode(shtTrlSec, forKey: "shtTrlSec")
        }
        if src != nil{
            aCoder.encode(src, forKey: "src")
        }
        if srcFeed != nil{
            aCoder.encode(srcFeed, forKey: "srcFeed")
        }
        if stm != nil{
            aCoder.encode(stm, forKey: "stm")
        }
        if totalAc != nil{
            aCoder.encode(totalAc, forKey: "totalAc")
        }
        
    }
    
}

