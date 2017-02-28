//
//  Constants.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import Foundation

let GPFlickrBaseUrl = "https://api.flickr.com/services/rest/?"
let GPFlickrSearchMethod = "method=flickr.photos.search&"
let GPFLickrPhotosMethod = "method=flickr.photos.getSizes&"
let GPFlickrAPIKey = "api_key=fe9944e50ef65a5c8c91d183ffe6d106&"
let GPFlickrOptions = "format=json&nojsoncallback=1"

let GPUserDefaultsTravelModeKey = "travelMode"
let GPUserDefaultsSearchDistanceKey = "searchDistance"

let GPTableViewCellTravelModeKey = "SettingsCellTravelMode"
let GPTableViewCellSearchDistanceKey = "SettingsCellDistance"

let GPNotificationUpdateDistanceFilter = "UpdateDistanceFilter"

let GPMapRegionRadius = 10000

enum GPTableViewCell : Int {
    case SearchDistance = 0
    case TravelMode = 1
}
