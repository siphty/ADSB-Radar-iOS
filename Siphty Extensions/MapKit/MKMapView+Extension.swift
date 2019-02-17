//
//  MKMapView+Extension.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 4/11/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import MapKit
import MapKitGoogleStyler

extension MKMapView {
  
  func configureTileOverlay(withJson jsonFileName: String) {
    // We first need to have the path of the overlay configuration JSON
    guard let overlayFileURLString = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
      return
    }
    let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
    
    // After that, you can create the tile overlay using MapKitGoogleStyler
    guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
      return
    }
    
    // And finally add it to your MKMapView
    addOverlay(tileOverlay)
  }
  
}
