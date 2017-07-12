//
//  ADSBAeroChartViewController.swift
//  HMD
//
//  Created by Yi JIANG on 8/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import MapKit

class ADSBAeroChartViewController: UIViewController {
    
    var arViewController: ARViewController!
    let locationManager = CLLocationManager()
    let notificationCenter = NotificationCenter.default
    
    fileprivate var homeLocation: CLLocation? {
        didSet {
            ADSBAPIClient.sharedInstance.adsbLoction = homeLocation
//            print("Home location have been setted as : \(homeLocation.debugDescription)")
        }
    }
    fileprivate var mapRegionLocation: CLLocation? {
        didSet {
            ADSBAPIClient.sharedInstance.adsbLoction = mapRegionLocation
            mapView.scanRegionCoordinate = mapRegionLocation?.coordinate
//            print("Map Region location have been setted as : \(mapRegionLocation.debugDescription)")
        }
    }
    fileprivate var uavLocation: CLLocation?
    fileprivate var distanceBackToHome = Float()
    fileprivate var regionRadius: CLLocationDistance = 30000
    fileprivate var aircrafts: [ADSBAircraft]?
    fileprivate var mapHeading: Double = 0.0
    fileprivate var isRotatingAnnotations: Bool = false
    fileprivate var uavAnnotation: ADSBAnnotation?
    fileprivate var homeAnnotation: MKAnnotation?
    fileprivate var mapChangedFromUserInteraction = false
    
    @IBOutlet var rangeRadiusLabel: UILabel!
    
    @IBOutlet var switchDesciptionLabel: UILabel!
    @IBOutlet var hideOnGroundACSwitch: UISwitch!
    
    enum MapLockOn {
        case none
        case home
        case uav
        case aircraft
    }
    var mapLockOn = MapLockOn.home
    
    @IBOutlet weak var mapView: ADSBMapView!
    
    @IBAction func uavButtomTouchUpInside(_ sender: Any) {
        if mapLockOn == .uav {
            mapChangedFromUserInteraction = true
            mapLockOn = .none
            centerMapOnUAVAndHome()
            return
        } else {
            mapChangedFromUserInteraction = false
            mapLockOn = .uav
        }
        
        if uavLocation != nil {
            centerMapOnLocation(uavLocation!)
        }
    }
    
    @IBAction func remoteButtonTouchUpInside(_ sender: Any) {
        if mapLockOn == .home {
            mapChangedFromUserInteraction = true
            mapLockOn = .none
            centerMapOnUAVAndHome()
            return
        } else {
            mapChangedFromUserInteraction = false
            mapLockOn = .home
        }
        if homeLocation != nil {
            centerMapOnLocation(homeLocation!)
        }
        
    }
    
    
    fileprivate var aircraftAnnotations = [ADSBAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Home Location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        mapView.listener = self
        mapView.delegate = self
        mapView.bounds = view.bounds
        mapView.scanRadius = regionRadius
        hideOnGroundACSwitch.setOn(ADSBConfig.isGroundAircraftFilterOn, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Start updating ADS-B aircrafts
        notificationCenter.addObserver(self,
                                       selector: #selector(aircraftListHasBeenUpdated),
                                       name: ADSBNotification.NewAircraftListKey,
                                       object: nil)
        let apiClient = ADSBAPIClient.sharedInstance
        apiClient.adsbLoction = homeLocation
        apiClient.startUpdateAircrafts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ADSBAPIClient.sharedInstance.stopUpdateAircrafts()
        notificationCenter.removeObserver(self, name: ADSBNotification.NewAircraftListKey, object: nil)
    }
    
    
    
    //MARK: UIGestureRecognizerDelegate
    fileprivate func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    @IBAction func radarRangeSliderTouchDown(_ sender: Any) {
        print("radarRangeSliderTouchDown")
        rangeRadiusLabel.isHidden = false
    }
    
    @IBAction func radarRangeSliderTouchUp(_ sender: Any) {
        print("radarRangeSliderTouchUp")
        rangeRadiusLabel.isHidden = true
    }
    

    @IBAction func radarRangeSliderValueChanged(_ sender: Any) {
        let rangeRadius = (sender as! UISlider).value
        rangeRadiusLabel.text = String("\(Int(rangeRadius)) KM")
        ADSBConfig.scanRangeBase = rangeRadius
        mapView.scanRadius = CLLocationDistance(rangeRadius * 1000)
    }
    
    @IBAction func displayOnGroundSwitchValueChanged(_ sender: Any) {
        let isOn = (sender as! UISwitch).isOn
        ADSBConfig.isGroundAircraftFilterOn = isOn
        if isOn {
            switchDesciptionLabel.text = "Hidden aircrafts on the ground"
            removeOnGroundAircraftAnnotation()
        } else {
            switchDesciptionLabel.text = "Displayed all aircrafts"
        }
    }
}

//MARK: MKMapViewDelegate
extension ADSBAeroChartViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKCircle
        {
            let regionCircleRenderer = MKCircleRenderer(overlay: overlay)
            regionCircleRenderer.fillColor = UIColor.black.withAlphaComponent(0.2)
            regionCircleRenderer.strokeColor = UIColor.green
            regionCircleRenderer.lineWidth = 2
            return regionCircleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if mapViewRegionDidChangeFromUserInteraction() {
            mapChangedFromUserInteraction = true
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapRegionLocation = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        if view.annotation is ADSBAnnotation {
            let adsbAnnotation = view.annotation as! ADSBAnnotation
            guard let callout: ADSBAnnotationCalloutView = (view as! ADSBAnnotationView).calloutView else { return }
            if self.isLocationAvailabe() {
                callout.startLoading()
                self.getAircraft(by: adsbAnnotation.identifier, completion: { (aircraft) in
                    callout.stopLoading()
                })
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("callout accessary ")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var theAnnotationView: ADSBAnnotationView?
        if annotation is ADSBAnnotation {
            let theAnnotation = annotation as! ADSBAnnotation
            if theAnnotation.identifier == kUAVAnnotationId {
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotation.image = #imageLiteral(resourceName: "AeroChartDroneIcon")
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kUAVAnnotationId)
                    guard (theAnnotation.location != nil) else { return nil }
                    theAnnotationView?.transform = (theAnnotationView?.transform.rotated(by:Geometric.degreeToRadian((theAnnotation.location?.course)! + mapHeading)))!
                }
            } else if theAnnotation.identifier.range(of: kAircraftAnnotationId) != nil {
                theAnnotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView(annotation: theAnnotation, reuseIdentifier: theAnnotation.identifier)
//                    theAnnotationView?.canShowCallout = true
                    guard (theAnnotation.location != nil) else { return nil }
                    let adsbMapView = mapView as! ADSBMapView
                    let altitudeX = adsbMapView.getScaleHeight(by: CGFloat((theAnnotation.aircraft?.presAltitude) ?? 0), on: adsbMapView.altitudeStickLayer)
                    var altitudeColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    if !(theAnnotation.aircraft?.isOnGround ?? false) {
                        altitudeColor = adsbMapView.altitudeStickLayer.getColorfromPixel(CGPoint(x: 2, y: altitudeX))
                    }
                    theAnnotationView?.annotationImage = theAnnotation.image.maskWithColor(color: altitudeColor)!
                    let turnRadian = Geometric.degreeToRadian((theAnnotation.location?.course)! + mapHeading)
                    let transform = theAnnotationView?.annotationImageView?.transform.rotated(by: turnRadian)
                    theAnnotationView?.annotationImageView?.transform = transform!
                }
            } else if theAnnotation.identifier == kAerodromeAnnotationId {
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotation.image = #imageLiteral(resourceName: "AeroChartRunwayIcon")
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAerodromeAnnotationId)
                    let turnRadian = Geometric.degreeToRadian((theAnnotation.location?.course)! + mapHeading)
                    theAnnotationView?.transform = (theAnnotationView?.transform.rotated(by:turnRadian))!
                }
            } else {
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotation.image = #imageLiteral(resourceName: "AeroChartHomeBottom")
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kRemoteAnnotationId)
                    let turnRadian = Geometric.degreeToRadian((theAnnotation.location?.course)! + mapHeading)
                    theAnnotationView?.transform = (theAnnotationView?.transform.rotated(by:turnRadian))!
                }
            }
        } else {
            return nil
        }
        return theAnnotationView
    }
}

//MARK: ADSBMapViewListener
extension ADSBAeroChartViewController: ADSBMapViewListener {
    func mapView(_ mapView: ADSBMapView, rotationDidChange rotation: Double) {
        if isRotatingAnnotations {
            return
        }
        isRotatingAnnotations = true
        let mapRotatedAngle = mapHeading - rotation
        mapHeading = rotation
        for anAnnotation in mapView.annotations{
            guard let theAnnotation = anAnnotation as? ADSBAnnotation else {
                continue
            }
            guard  let theAnnotationView =  mapView.view(for: theAnnotation) as? ADSBAnnotationView else {
                continue
            }
            theAnnotationView.annotationImageView?.transform = (theAnnotationView.annotationImageView?.transform.rotated(by:Geometric.degreeToRadian(mapRotatedAngle)))!
        }
        isRotatingAnnotations = false
    }
}

//MARK: CLLocationManagerDelegate
extension ADSBAeroChartViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var isLocationAutorized = false
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
            homeLocation = locationManager.location
            isLocationAutorized = true
        case .denied, .notDetermined, .restricted:
            isLocationAutorized = false
            homeLocation = nil
        }
        if !isLocationAutorized {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if mapLockOn == .home && !mapChangedFromUserInteraction{
            homeLocation = locations.last
            centerMapOnLocation(homeLocation!)
            mapView.scanRegionCoordinate = locations.last?.coordinate
        }
    }
}

//MARK: Miscellaneous
extension ADSBAeroChartViewController{
    func centerMapOnLocation(_ location: CLLocation) {
        if mapChangedFromUserInteraction {
            return
        }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnUAVAndHome() {
        if mapChangedFromUserInteraction {
            return
        }
        guard (uavLocation != nil) else {
            return
        }
        guard (homeLocation != nil) else {
            return
        }
        let regionRadius = homeLocation!.distance(from: uavLocation!)
        let region = MKCoordinateRegionMakeWithDistance(homeLocation!.getMidpointTo(uavLocation!).coordinate,
                                                        regionRadius * 2.2 + ADSBConfig.minimumMapViewRange,
                                                        regionRadius * 2.2 + ADSBConfig.minimumMapViewRange)
        mapView.setRegion(region, animated: true)
    }
    
    func updateAnnotation(_ identifier: String, withLocation location: CLLocation, aircraft: ADSBAircraft?){
        
        for exsitingAnnotation in mapView.annotations{
            guard let annotation = exsitingAnnotation as? ADSBAnnotation else {
                continue
            }
            if annotation.identifier == identifier {
                let angleDiff: CGFloat = CGFloat(location.course - annotation.location!.course)
                let annotationView =  mapView.view(for: annotation) as? ADSBAnnotationView
                if annotationView != nil {
                    annotationView?.canShowCallout = false
                    let altitudeX = mapView.getScaleHeight(by: CGFloat((aircraft?.presAltitude) ?? 0), on: mapView.altitudeStickLayer)
                    var altitudeColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    if !(annotation.aircraft?.isOnGround ?? false)! {
                        altitudeColor = mapView.altitudeStickLayer.getColorfromPixel(CGPoint(x: 2, y: altitudeX))
                    }
                    annotationView?.annotationImage = annotation.image.maskWithColor(color: altitudeColor)!
                    annotationView?.annotationImageView?.transform = (annotationView?.annotationImageView?.transform.rotated(by:Geometric.degreeToRadian(angleDiff)))!
                }
                annotation.coordinate = location.coordinate
                annotation.location = location
                
                return
            }
        }
        let newAnnotation = createAnnotation(identifier, location: location, aircraft: aircraft)
        mapView.addAnnotation(newAnnotation)
    }
    
    func createAnnotation(_ identifier: String, location: CLLocation, aircraft: ADSBAircraft?) -> ADSBAnnotation {
        let annotation = ADSBAnnotation()
        // if the location services is on we will show the travel time, so we give a blank title to mapPin to draw a bigger callout for AnnotationView loader
        annotation.title = String("TITLE")
        annotation.identifier = identifier
        annotation.subtitle = identifier
        annotation.coordinate = location.coordinate
        annotation.location = location
        annotation.aircraft = aircraft
//        aircraftAnnotations.append(annotation) // For AR View
        return annotation
    }
    
    
    // MARK: Location Services Helpers
    
    /// checks whehter user's has authorised the location services for this app or not
    ///
    /// - Returns: `true` if the user has authorised this app for using location services
    fileprivate func isLocationAuthorized() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        }
    }
    
    /// checks  if the location services has been authorised and the location services is on
    ///
    /// - Returns: `true` if location services is on and the app has been authorised otherwise `false`
    fileprivate func isLocationAvailabe() -> Bool {
        return isLocationAuthorized() && CLLocationManager.locationServicesEnabled()
    }
    
    fileprivate func getAircraft(by identifier: String, completion : @escaping (_ aircraft: ADSBAircraft?) -> Void) {
        //Search aircraft list by identifier
        let aircraftList = ADSBCacheManager.sharedInstance.adsbAircrafts
        for aircraft in aircraftList {
            let aircraftIdentifier = kAircraftAnnotationId + (aircraft.icaoId ?? "") + (aircraft.registration ?? "")
            if aircraftIdentifier == identifier {
                completion(aircraft)
            }
        }
        completion(nil)
    }
    
    fileprivate func getAircraftType(of identifier: String) -> String {
        return "normal airplane"
    }
    
    @objc func aircraftListHasBeenUpdated(){
        let aircraftList = ADSBCacheManager.sharedInstance.adsbAircrafts
        for aircraft in aircraftList {
            if (aircraft.isOnGround ?? false)  && ADSBConfig.isGroundAircraftFilterOn { continue }
            let annotationId = kAircraftAnnotationId + (aircraft.icaoId ?? "") + (aircraft.registration ?? "")
            if aircraft.latitude == nil || aircraft.longitude == nil { continue }
            let latitude = CLLocationDegrees(aircraft.latitude!)
            let longitude = CLLocationDegrees(aircraft.longitude!)
            let coordination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let altitude = CLLocationDistance(aircraft.presAltitude ?? 0)
            let speed = CLLocationSpeed(aircraft.groundSpeed ?? 0)
            let heading = CLLocationDirection(aircraft.trackHeading ?? 0)
            updateAnnotation(annotationId,
                             withLocation: CLLocation(coordinate: coordination,
                                                        altitude: altitude,
                                                        horizontalAccuracy: CLLocationAccuracy(10),
                                                        verticalAccuracy:  CLLocationAccuracy(10),
                                                        course: heading,
                                                        speed: speed,
                                                        timestamp: Date()),
                             aircraft: aircraft)
            
        }
        cleareExpiredAnnotation()
        updateARViewAnnotations()
//        aircraftAnnotations.append(annotation) // For AR View
    }
    
    //Remove all annotation
    func cleareExpiredAnnotation(){
        for anAnnotation in mapView.annotations {
            if anAnnotation is ADSBAnnotation {
                let theAnnotation = anAnnotation as! ADSBAnnotation
                let secondsInterval = Date().timeIntervalSince((theAnnotation.location?.timestamp)!)
                if secondsInterval > ADSBConfig.expireSeconds {
                    mapView.removeAnnotation(theAnnotation)
                } else if secondsInterval > 1 {
                    guard let theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView else {
                        continue
                    }
                    //FIXME: This doesn't work properly : Fade annotation icon alpha before expire
                    theAnnotationView.annotationImageView?.alpha = ((theAnnotationView.annotationImageView?.alpha) ?? 1) / 4
                }
            }
        }
    }
    
    func removeOnGroundAircraftAnnotation() {
        for anAnnotation in mapView.annotations {
            if anAnnotation is ADSBAnnotation {
                let theAnnotation = anAnnotation as! ADSBAnnotation
                if theAnnotation.aircraft?.isOnGround ?? false{
                    mapView.removeAnnotation(theAnnotation)
                }
            }
        }
    }
    
}


//AR View related func
extension ADSBAeroChartViewController {
    
    @IBAction func arViewButtonTouchUpInside(_ sender: Any) {
        guard mapView.annotations.count != 0 else { return }
        var annotationArray = [ADSBAnnotation]()
        for annotation in mapView.annotations {
            if annotation is ADSBAnnotation {
                annotationArray.append(annotation as! ADSBAnnotation)
            }
        }
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 30
        arViewController.headingSmoothingFactor = 0.95 //0.05
        
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(annotationArray)
        arViewController.uiOptions.debugEnabled = false
        arViewController.uiOptions.closeButtonEnabled = true
        
        self.present(arViewController, animated: true, completion: nil)
        
    }
    
    func updateARViewAnnotations(){
        
    }
    
}


extension ADSBAeroChartViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ADSBAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
    }
    
    
}



extension ADSBAeroChartViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation {
            print("Annotation is beed touched: \(String(describing: annotation.aircraft?.icaoId))")
            
        }
    }
}







