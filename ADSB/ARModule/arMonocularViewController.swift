//
//  arMonocularViewController.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 9/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import AVFoundation

class arMonocularViewController: UIViewController, ARViewDelegate {
    
    var flightTestMode : Bool = true
    
    var flightImage : [String : UIImage] = [:]
    
    var flightAnnotations : [String : FlightAnnotation] = [:]
    
    var flightAnnotationsGeo : [String : ARGeoCoordinate] = [:]
    
    let locationManager = CLLocationManager()
    
    var currentView : ViewController?
    
    var points : [ARGeoCoordinate] = []
    
    var arKitEngine : ARKitEngine? = nil
    
    var userLocation: CLLocation?
    
    fileprivate var closeButton: UIButton?
    fileprivate var compassImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                } else {
                    // User Rejected
                    self.dismiss(animated: true) { }
                }
            })
        }
        readTestFlights()
        generateGeoCoordinatesFromFlightAnnotaiton(annotations: Array(flightAnnotations.values))
        startFlightARView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToRadarButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true) { }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func startFlightARView(){
        let config = ARKitConfig.defaultConfig(for: self)
        config?.useAltitude = true
        config?.orientation=UIApplication.shared.statusBarOrientation
        config?.scaleViewsBasedOnDistance = false
        
        // for radar display
        let s = UIScreen.main.bounds.size
        if UIApplication.shared.statusBarOrientation.isPortrait{
            config?.radarPoint = CGPoint(x: s.width - 50, y: s.height - 50)
        }else{
            config?.radarPoint = CGPoint(x: s.height - 50, y: s.width - 50)
        }
        
        arKitEngine = ARKitEngine.init(config: config)
        arKitEngine?.addCoordinates(points)
        self.addCompassView()
        self.addCloseButton()
        //
        arKitEngine?.startListening()
    }

    
    
    func addCompassView(){
        let view = UIImageView()
        view.frame = CGRect(x: 10, y: 10, width: 80, height: 78)
        //view.backgroundColor = UIColor.white
        view.image = #imageLiteral(resourceName: "compass")
        self.compassImage = view
        
        self.arKitEngine?.addExtraView(view)
        
    }
    
    
    //CLOSE button on AR flight view
    func addCloseButton()
    {
        self.closeButton?.removeFromSuperview()
        
        // Close button - make it customizable
        let closeButton: UIButton = UIButton(type: UIButtonType.custom)
        closeButton.setImage(#imageLiteral(resourceName: "RadarButtonIcon"), for: UIControlState());
        closeButton.frame = CGRect(x: self.view.bounds.size.width - 45, y: 5,width: 40,height: 40)
        closeButton.addTarget(self, action: #selector(closeAR), for: UIControlEvents.touchUpInside)
        closeButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.closeButton = closeButton
        self.arKitEngine?.addExtraView(closeButton)
    }
    
    internal func closeButtonTap()
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func closeAR() {
        arKitEngine?.hide()
    }
    
    
    open func generateGeoCoordinatesFromFlightAnnotaiton(annotations: [FlightAnnotation])
    {
        // Don't use annotations without valid location
        for annotation in annotations
        {
            if CLLocationCoordinate2DIsValid(annotation.coordinate)
            {
                let timeInterval:TimeInterval=Double(annotation.lastUpdatedInMillis)/1000
                
                let arGeoCoordinate: ARGeoCoordinate = ARGeoCoordinate(
                    location: CLLocation.init(coordinate: annotation.coordinate, altitude: annotation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, course: annotation.heading , speed: annotation.speed, timestamp: NSDate(timeIntervalSinceNow: timeInterval) as Date))
                arGeoCoordinate.dataObject = annotation
                arGeoCoordinate.calibrate(usingOrigin: userLocation, useAltitude: true)
                
                self.flightAnnotationsGeo[annotation.title!] = arGeoCoordinate
                
                self.points.append(arGeoCoordinate)
            }
        }
    }
}

extension arMonocularViewController: LocalizationDelegate {
    public func locationUnavailable() {
        //
    }

    @available(iOS 2.0, *)
    public func locationFound(_ location: CLLocation!) {
        userLocation = location
    }

    @available(iOS 3.0, *)
    public func headingFound(_ heading: CLHeading!) {
        self.rotateCompass(newHeading: fmod(heading.trueHeading, 360.0))
    }
}

extension arMonocularViewController {//: ARViewDelegate {
    
    
    public func didChangeLooking(_ floorLooking: Bool) {
        if (floorLooking) {
            // The user has began looking at the floor
            print("floor looking")
        } else {
            // The user has began looking front
            print("not floor looking")
        }
    }
    
    public func itemTouched(with index: Int) {
        
    }
    
    
    public func view(for coordinate: ARGeoCoordinate!, floorLooking: Bool) -> ARObjectView! {
        var arObjectView : ARObjectView? = nil
        
        let annotation  = coordinate.dataObject as! FlightAnnotation
        
        if floorLooking {
            arObjectView = ARObjectView.init()
            arObjectView?.displayed = false
        }else{
            
            let flightBubbleView = FlightBubble()
            flightBubbleView.frame = CGRect(x: 0,y: 0,width: 170,height: 50)
            let arAnnotation = ARAnnotation()
            arAnnotation.title = annotation.title
            arAnnotation.altitude = annotation.altitude
            arAnnotation.coordinate = annotation.coordinate
            arAnnotation.radialDistance = coordinate.radialDistance.multiplied(by: 0.00062)
            
            flightBubbleView.annotation = arAnnotation
            flightBubbleView.annotation?.annotationView = flightBubbleView
            //flightBubbleView.loadUi()
            
            arObjectView = ARObjectView.init(frame: flightBubbleView.frame)
            arObjectView?.addSubview(flightBubbleView)
            
        }
        arObjectView?.sizeToFit()
        return arObjectView
        
    }
}

extension arMonocularViewController {
    
    
    
    func readTestFlights(){
        if let path = Bundle.main.path(forResource: "TestFlights", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let flightJSONObjects = JSON(data: data)
                if flightJSONObjects != JSON.null {
                    // print("jsonData:\(flightJSONObjects)")
                    
                    let flights = flightJSONObjects["flights"].arrayValue
                    for flight in flights {
                        guard let flightInfo = FlightInfo(json: flight) else { continue }
                        
                        let flightAnnotation = FlightAnnotation(coordinate:CLLocationCoordinate2D(latitude: flightInfo.latitude,longitude: flightInfo.longitude))
                        flightAnnotation.title=flightInfo.icao
                        flightAnnotation.coordinate=CLLocationCoordinate2D(latitude: flightInfo.latitude,longitude: flightInfo.longitude)
                        // the logic of showing plane based on flight can be done here based on the icao code.
                        flightAnnotation.image=#imageLiteral(resourceName: "target").rotated(by: flightInfo.headingInDegrees)
                        flightAnnotation.altitude=flightInfo.altitudeInMeters
                        flightAnnotation.speed=flightInfo.velocityInMetersPerSecond
                        flightAnnotation.lastUpdatedInMillis=flightInfo.lastUpdatedInMillis
                        flightAnnotation.heading=flightInfo.headingInDegrees
                        flightAnnotation.testFlight = true
                        flightAnnotation.callSign=flightInfo.callSign
                        flightAnnotations[flightInfo.icao!] = flightAnnotation
                    }
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    
    internal func rotateCompass(newHeading: Double)
    {
        compassImage.transform = CGAffineTransform(rotationAngle: newHeading.toRadians())
    }
    
    /*
     * returning bubble view for AR
     */
    func createCalloutView() -> FlightBubbleV1 {
        let views = Bundle.main.loadNibNamed("FlightBubbleV1", owner: nil, options: nil)
        let bubbleView = views?[0] as! FlightBubbleV1
        return bubbleView
    }
}


extension Double {
    func toRadians() -> CGFloat {
        return CGFloat(self * .pi / 180.0)
    }
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIImage {
    func rotated(by degrees: Double, flipped: Bool = false) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let transform = CGAffineTransform(rotationAngle: degrees.toRadians())
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: degrees.toRadians())
            renderContext.cgContext.scaleBy(x: flipped ? -1.0 : 1.0, y: -1.0)
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
    
}
