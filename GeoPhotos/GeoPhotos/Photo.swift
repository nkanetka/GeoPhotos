//
//  Photo.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-28.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var id: String = "" {
        didSet {
            let serverHelper = ServerHelper()
            serverHelper.getImageDetails(photo: self)
        }
    }
    var city: String = ""
    var title: String = ""
    var state: String = ""
    var author: String = ""
    var county: String = ""
    var country: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var mediumImageURL: String = ""
    var image: UIImage!
    var photoDataDictionary: [String:Any] = [:] {
        willSet(newDictionary) {
            checkIfPhotoHasImageLoaded()
            if let photoData = newDictionary["photo"] as? [String:Any] {
                if let ownerData = photoData["owner"] as? [String:Any] {
                    if let realname = ownerData["realname"] as? String {
                        author = realname
                        if author.isEmpty {
                            if let username = ownerData["username"] as? String {
                                author = username
                            }
                        }
                    }
                }
                if let locationData = photoData["location"] as? [String:Any] {
                    if let lat = locationData["latitude"] as? String {
                        latitude = lat
                        if latitude.isEmpty {
                            latitude = GPUnknownString
                        }
                    }
                    if let lon = locationData["longitude"] as? String {
                        longitude = lon
                        if longitude.isEmpty {
                            longitude = GPUnknownString
                        }
                    }
                    if let localityData = locationData["locality"] as? [String:Any] {
                        if let content = localityData["_content"] as? String {
                            city = content
                            if city.isEmpty {
                                city = GPUnknownString
                            }
                        }
                    }
                    if let countyData = locationData["county"] as? [String:Any] {
                        if let content = countyData["_content"] as? String {
                            county = content
                            if county.isEmpty {
                                county = GPUnknownString
                            }
                        }
                    }
                    if let regionData = locationData["region"] as? [String:Any] {
                        if let content = regionData["_content"] as? String {
                            state = content
                            if state.isEmpty {
                                state = GPUnknownString
                            }
                        }
                    }
                    if let countryData = locationData["country"] as? [String:Any] {
                        if let content = countryData["_content"] as? String {
                            country = content
                            if country.isEmpty {
                                country = GPUnknownString
                            }
                        }
                    }
                }
            }
        }
    }
    var imageSizeDictionary: [String:Any] = [:] {
        willSet(newDictionary) {
            if let sizes = newDictionary["sizes"] as? [String:Any] {
                if let size = sizes["size"] as? [[String:Any]] {
                    for imageSize in size {
                        if let label = imageSize["label"] as? String {
                            if label == "Medium" {
                                self.mediumImageURL = imageSize["source"] as! String
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkIfPhotoHasImageLoaded() {
        if self.mediumImageURL != "" {
            if self.image == nil {
                let serverHelper = ServerHelper()
                serverHelper.getImageFor(photo: self)
            }
        }
    }
}
