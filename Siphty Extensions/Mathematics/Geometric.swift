//
//  Geometric.swift
//  HMD
//
//  Created by Yi JIANG on 15/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import CoreGraphics

class Geometric {
    static func degreeToRadian(_ degree:CGFloat) -> CGFloat {
        let radian = CGFloat(Double.pi) * degree/180
        return radian
    }
    static func degreeToRadian(_ degree:Double) -> CGFloat {
        let radian = CGFloat(Double.pi) * CGFloat(degree)/180
        return radian
    }
    static func degreeToRadian(_ degree:Int) -> CGFloat {
        let radian = CGFloat(Double.pi) * CGFloat(degree)/180
        return radian
    }
    static func degreeToRadian(_ degree:Float) -> CGFloat {
        let radian = CGFloat(Double.pi) * CGFloat(degree)/180
        return radian
    }
    static func degreeToRadian(_ degree:NSNumber) -> CGFloat {
        let radian = CGFloat(Double.pi) * CGFloat(truncating: degree)/180
        return radian
    }
}
