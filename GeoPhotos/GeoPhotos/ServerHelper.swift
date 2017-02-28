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
    var photosDictionaryArray: [[String:Any]] = [[:]]
    var photoURLsArray: [String] = []
    var photosArray: [UIImage] = []
    
    override init() {
        super.init()
    }
    
    func getPhotosFor(coordinate: CLLocationCoordinate2D) {
        let url = GPFlickrBaseUrl
        let safeSearch = "safe_search=1&"
        let lat = "lat=" + String(coordinate.latitude) + "&"
        let lon = "lon=" + String(coordinate.longitude) + "&"
        let radius = "radius=20&radius_units=km&" // FIXME: Change to be user given
        let options = "format=json&nojsoncallback=1"
        let message = safeSearch + GPFlickrSearchMethod + GPFlickrAPIKey + lat + lon + radius + options
        let requestURL = url + message
        self.callFlickrAPI(endpoint: requestURL)
    }
    
    func getPhotos(photoDictionaryArray: [[String:Any]]) {
        photosArray.removeAll()
        photoURLsArray.removeAll()
        
        for photo in photoDictionaryArray {
            if let photoID = photo["id"] as? String {
                let url = GPFlickrBaseUrl + GPFLickrPhotosMethod + GPFlickrAPIKey + "photo_id=" + photoID + "&" + GPFlickrOptions
                callFlickrAPI(endpoint: url)
            }
        }
    }
    
    func getImages() {
        for photoURL in self.photoURLsArray {
            self.callFlickrAPI(endpoint: photoURL)
        }
    }
    
    private func callFlickrAPI(endpoint: String) {
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
                            print("flickr.photos.search")
                            self.getArrayOfPhotosIDs(flickrJsonObject: json)
                        }
                        if endpoint.range(of: "flickr.photos.getSizes") != nil {
                            let json = self.parseData(data: data!)
                            print("flickr.photos.getSizes")
                            self.photoURLsArray.append(self.getPhotoURL(flickrJsonObject: json))
                            
                            if self.photoURLsArray.count == self.photosDictionaryArray.count {
                                self.getImages()
                            }
                        }
                        if endpoint.range(of: "farm") != nil {
                            self.photosArray.append(UIImage(data: data!)!)
                            
                            if self.photosArray.count == self.photoURLsArray.count {
                                self.delegate?.didFetchPhotos(newPhotos: self.photosArray)
                            }
                            print("Calling API")
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
        })
        task.resume()
    }
    
    private func parseData(data: Data) -> [String:Any] {
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
        if let photos = flickrJsonObject["photos"] as? [String:Any] {
            photosDictionaryArray = photos["photo"] as! [[String : Any]]
            delegate?.didRecievePhotos(photosArray: photosDictionaryArray)
        }
    }
    
    private func getPhotoURL(flickrJsonObject: [String:Any]) -> String {
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
    func didRecievePhotos(photosArray: [[String:Any]])
    func didFetchPhotos(newPhotos: [UIImage])
}
