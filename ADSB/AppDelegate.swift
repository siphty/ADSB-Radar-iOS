//
//  AppDelegate.swift
//  ADSB
//
//  Created by Yi JIANG on 4/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let defaults = UserDefaults.standard
//        let documentsDir = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        print("documentsDir : \(documentsDir)")
//        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
//                AirdomeCommon.sharedInstance.parseAirportCSV()
//                AirdomeCommon.sharedInstance.parseRunwayCSV()
//        AirdomeCommon.sharedInstance.usePrePopulatedDB()
//            }
//        }
//        AirdomeCommon.sharedInstance.demoAirportRecords()
        
        //MARK: LocationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = 10
        locationManager.distanceFilter = 20
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "self.edu.SomeJunk" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "airport", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "airport")
        
        let dbName: String = "airport"
        var persistentStoreDescriptions: NSPersistentStoreDescription

        let storeUrl = self.getDocumentsDirectory().appendingPathComponent("airport.sqlite")
        
        if !FileManager.default.fileExists(atPath: (storeUrl.path)) {
            let seededDataUrl = Bundle.main.url(forResource: dbName, withExtension: "sqlite")
            try! FileManager.default.copyItem(at: seededDataUrl!, to: storeUrl)
        }

        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl

        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getDocumentsDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationDict:[String: CLLocation] = ["location": (locations.last)!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:LMNotification.didUpdateLocations),
                                        object: nil,
                                        userInfo: locationDict)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthDict:[String: CLAuthorizationStatus] = ["CLAuthorizationStatus": status]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:LMNotification.didChangeAuthorization),
                                        object: nil,
                                        userInfo: locationAuthDict)
    }
    
    // MARK: geo fence
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region, isEnterRegion: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region, isEnterRegion: false)
        }
    }
    
    func handleEvent(forRegion region: CLRegion!, isEnterRegion: Bool) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            guard let geotification = geotification(fromRegionIdentifier: region.identifier) else { return }
            let message = note(fromGeotification: geotification, isEnterRegion: isEnterRegion)
            if isEnterRegion {
                if !message.isEmpty {
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        // refetch geochatrooms
                        GeofenceManager.sharedInstance.fetchGeolocationsWithLocation(geotification.coordinate)
                    }))
                    window?.rootViewController?.present(alert, animated: true, completion: nil)
                } else {
                    // refetch geochatrooms
                    GeofenceManager.sharedInstance.fetchGeolocationsWithLocation(geotification.coordinate)
                }
            } else if !isEnterRegion {
                let locationDict:[String: CLLocation] = ["location": CLLocation(latitude: geotification.coordinate.latitude, longitude: geotification.coordinate.longitude) ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:LMNotification.didUpdateLocations), object: nil, userInfo: locationDict)
            }
        } else {
            guard let geotification = geotification(fromRegionIdentifier: region.identifier) else { return }
            let message = note(fromGeotification: geotification, isEnterRegion: isEnterRegion)
            if !message.isEmpty {
                // Otherwise present a local notification
                let notification = UILocalNotification()
                notification.alertBody = message
                notification.soundName = "Default"
                UIApplication.shared.presentLocalNotificationNow(notification)
                
                // refetch geochatrooms
                GeofenceManager.sharedInstance.fetchGeolocationsWithLocation(geotification.coordinate)
            }
        }
    }
    
    func geotification(fromRegionIdentifier identifier: String) -> Geotification? {
        let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
        let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
        let index = geotifications?.index { $0?.identifier == identifier }
        return index != nil ? geotifications?[index!] : nil
    }
    
    func note(fromGeotification geotification: Geotification?, isEnterRegion: Bool) -> String {
        guard let geo = geotification else {
            return ""
        }
        if isEnterRegion {
            return "You've entered \(String(describing: geo.note))"
        } else {
            return "You've left \(String(describing: geo.note))"
        }
    }
    
}




