//
//  Collection+extensions.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 31/12/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index, Index == Int {
    public subscript (safe index: Index) -> Iterator.Element? {
        return index < self.count ? self[index] : nil
    }
}
