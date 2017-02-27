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
    var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
    }
    
    func initialize() {
        setupLocationManager()
        self.resquestWhenInUseAuthorization()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func resquestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
