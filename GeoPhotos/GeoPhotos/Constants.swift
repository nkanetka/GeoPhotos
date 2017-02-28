//
//  Constants.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import Foundation

// Flickr API Constants
let GPFlickrBaseUrl = "https://api.flickr.com/services/rest/?"
let GPFlickrSearchMethod = "method=flickr.photos.search&"
let GPFLickrPhotosMethod = "method=flickr.photos.getSizes&"
let GPFlickrAPIKey = "api_key=fe9944e50ef65a5c8c91d183ffe6d106&"
let GPFlickrOptions = "format=json&nojsoncallback=1"

// UserDefaults Keys
let GPUserDefaultsTravelModeKey = "travelMode"
let GPUserDefaultsSearchDistanceKey = "searchDistance"

// CollectionViewCell Identifiers
let GPCollectionViewCellReuseIdentifier = "CollectionViewCell"

// TableViewCells Identifiers
let GPTableViewCellTravelModeKey = "SettingsCellTravelMode"
let GPTableViewCellSearchDistanceKey = "SettingsCellDistance"

// DistanceFilter Notification
let GPNotificationUpdateDistanceFilter = "UpdateDistanceFilter"
let GPNotificationStopUpdatingLocation = "StopUpdatingLocation"

// String Constants
let GPUnknownString = "Unknown"

// Number Constants
let GPMapRegionRadius = 10000

enum GPTableViewCell : Int {
    case SearchDistance = 0
    case TravelMode = 1
}
