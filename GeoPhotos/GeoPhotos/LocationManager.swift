//
//  LocationManager.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    var delegate: LocationManagerDelegate?
    var locationManager: CLLocationManager = CLLocationManager()
    var mostRecentLocation: CLLocation? = nil
    let notificationCenter = NotificationCenter.default
    
    override init() {
        super.init()
    }
    
    func initialize() {
        setupLocationManager()
        self.resquestWhenInUseAuthorization()
        notificationCenter.addObserver(self, selector:#selector(LocationManager.setDistanceFilter), name: NSNotification.Name(rawValue: GPNotificationUpdateDistanceFilter), object: nil)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 200
    }
    
    func setDistanceFilter() {
        locationManager.distanceFilter = CLLocationDistance((searchDistance * 1000) / 2)
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func resquestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mostRecentLocation = locations.last as CLLocation!
        delegate?.didRecieveLocationUpdate(newLocation: mostRecentLocation!)
        print("Location Update")
    }
}

protocol LocationManagerDelegate {
    func didRecieveLocationUpdate(newLocation: CLLocation)
}
