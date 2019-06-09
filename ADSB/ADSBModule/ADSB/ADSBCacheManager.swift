//
//  ADSBCacheManager.swift
//  HMD
//
//  Created by Yi JIANG on 17/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

public final class ADSBCacheManager {
    
    static let sharedInstance = ADSBCacheManager()
    
    var adsbAircrafts = [Aircraft]() {
        didSet{
            //Broadcast notification
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: ADSBNotification.NewAircraftListKey, object: nil)
            print("Broadcast notification for new flights")
        }
    }
    
    var airports: [Airport] = [Airport]() {
        didSet{
            //Broadcast notification
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: ADSBNotification.NewAerodromeListKey, object: nil)
            print("Broadcast notification for new aerodromes")
            
        }
    }
}
