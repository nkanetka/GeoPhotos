//
//  ServerHelper.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ServerHelper: NSObject {
    
    var delegate: ServerHelperDelegate?
    var photosArray: [Photo] = []
    var gettingSingleImage: Bool = false
//    let notificationCenter = NotificationCenter.default
    
    override init() {
        super.init()
    }
    
    func getPhotosFor(coordinate: CLLocationCoordinate2D) {
        let url = GPFlickrBaseUrl
        let safeSearch = "safe_search=1&"
        let lat = "lat=" + String(coordinate.latitude) + "&"
        let lon = "lon=" + String(coordinate.longitude) + "&"
        let radius = "radius=" + String(searchDistance) + "&radius_units=km&"
        var perPage = "per_page="
        if travelMode {
            perPage = perPage + "20&"
        }
        else {
            perPage = perPage + "100&"
        }
        let options = "format=json&nojsoncallback=1"
        let message = safeSearch + GPFlickrSearchMethod + GPFlickrAPIKey + lat + lon + radius + perPage + options
        let requestURL = url + message
        self.callFlickrAPI(endpoint: requestURL, photo: nil)
    }
    
    func getDictionaryOfPhotoSizesFor(listOfPhotos: [Photo]) {
        photosArray.removeAll()
        photosArray = listOfPhotos
        for photo in listOfPhotos {
            let url = GPFlickrBaseUrl + GPFLickrPhotosMethod + GPFlickrAPIKey + "photo_id=" + photo.id + "&" + GPFlickrOptions
            callFlickrAPI(endpoint: url, photo: photo)
        }
    }
    
    func getImagesFor(listOfPhotos: [Photo]) {
        photosArray.removeAll()
        photosArray = listOfPhotos
        
        for photo in listOfPhotos {
            if photo.mediumImageURL != "" {
                self.callFlickrAPI(endpoint: photo.mediumImageURL, photo: photo)
            }
        }
    }
    
    func getImageDetails(photo: Photo) {
         let endpoint = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=fe9944e50ef65a5c8c91d183ffe6d106&photo_id=" + photo.id + "&format=json&nojsoncallback=1"
        callFlickrAPI(endpoint: endpoint, photo: photo)
    }
    
    func getImageFor(photo: Photo) {
        gettingSingleImage = true
        if photo.mediumImageURL != "" {
            self.callFlickrAPI(endpoint: photo.mediumImageURL, photo: photo)
        }
    }
    
    private func callFlickrAPI(endpoint: String, photo: Photo?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var request = URLRequest(url: URL(string: endpoint)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if endpoint.range(of: "flickr.photos.search") != nil {
                            let json = self.parseData(data: data!)
                            self.getArrayOfPhotosIDs(flickrJsonObject: json)
                        }
                        if endpoint.range(of: "flickr.photos.getSizes") != nil {
                            let json = self.parseData(data: data!)
                            photo?.imageSizeDictionary = json
                            
                            if (photo?.isEqual(self.photosArray.last))! {
                                self.delegate?.didRecieveDictionaryOfPhotoSize(photosArray: self.photosArray)
                            }
                        }
                        if endpoint.range(of: "farm") != nil {
                            photo?.image = UIImage(data: data!)!
                            
                            if self.gettingSingleImage {
                                self.delegate?.updateCollectionViewPhoto(photoToUpdate: photo!)
                                self.gettingSingleImage = false
                                
                            }
                            else {
                                if (photo?.isEqual(self.photosArray.last))! {
                                    self.delegate?.didRecievePhotos(photosArray: self.photosArray)
                                }
                            }
                        }
                        if endpoint.range(of: "flickr.photos.getInfo") != nil {
                            let json = self.parseData(data: data!)
                            photo?.photoDataDictionary = json
                        }
                    default:
                        print("---- Error calling API ----")
                        print("Status Code: %u", httpResponse.statusCode)
                    }
                }
            }
            else {
                print("---- Error Calling Flickr API ----")
                print(error.debugDescription)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        task.resume()
    }
    
    func parseData(data: Data) -> [String:Any] {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            return json!
        }
        catch {
            print("---- Error Serializing JSON Object From Flickr API ----")
            return ["":""]
        }
    }
    
    private func getArrayOfPhotosIDs(flickrJsonObject: [String:Any]) {
        photosArray.removeAll()
        if let photos = flickrJsonObject["photos"] as? [String:Any] {
            let photosDictionaryArray = photos["photo"] as! [[String : Any]]
            
            for photo in photosDictionaryArray {
                let newPhoto = Photo()
                newPhoto.id = photo["id"] as! String
                newPhoto.title = photo["title"] as! String
                photosArray.append(newPhoto)
            }
            delegate?.didRecieveListOfPhotos(photosArray: photosArray)
        }
    }
    
    private func getMediumPhotoURL(flickrJsonObject: [String:Any]) -> String {
        if let sizes = flickrJsonObject["sizes"] as? [String:Any] {
            if let size = sizes["size"] as? [[String:Any]] {
                for imageSize in size {
                    if let label = imageSize["label"] as? String {
                        if label == "Medium" {
                            return imageSize["source"] as! String
                        }
                    }
                }
            }
        }
        return ""
    }
}

protocol ServerHelperDelegate {
    func didRecieveListOfPhotos(photosArray: [Photo])
    func didRecieveDictionaryOfPhotoSize(photosArray: [Photo])
    func didRecievePhotos(photosArray: [Photo])
    func updateCollectionViewPhoto(photoToUpdate: Photo)
}
