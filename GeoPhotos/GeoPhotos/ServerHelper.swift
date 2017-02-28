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
    var presentlySearching: Bool = false
    var photosDictionaryArray: [[String:Any]] = [[:]]
    var photoURLsArray: [String] = []
    var photosArray: [UIImage] = []
    var array: [Photo] = []
    
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
        self.callFlickrAPI(endpoint: requestURL, photo: nil)
    }
    
    func getDictionaryOfPhotoSizesFor(listOfPhotos: [Photo]) {
        if presentlySearching == false {
//            presentlySearching = true
            array.removeAll()
            array = listOfPhotos
            for photo in listOfPhotos {
                let url = GPFlickrBaseUrl + GPFLickrPhotosMethod + GPFlickrAPIKey + "photo_id=" + photo.id + "&" + GPFlickrOptions
                callFlickrAPI(endpoint: url, photo: photo)
            }
        }
    }
    
    func getPhotos(photoDictionaryArray: [[String:Any]]) {
//        photosArray.removeAll()
//        photoURLsArray.removeAll()
//        
//        for photo in photoDictionaryArray {
//            if let photoID = photo["id"] as? String {
//                let url = GPFlickrBaseUrl + GPFLickrPhotosMethod + GPFlickrAPIKey + "photo_id=" + photoID + "&" + GPFlickrOptions
//                callFlickrAPI(endpoint: url)
//            }
//        }
    }
    
    func getImagesFor(listOfPhotos: [Photo]) {
        print("Getting Images")
        print("count: %@", listOfPhotos.count)
        array.removeAll()
        array = listOfPhotos
        
        for photo in listOfPhotos {
            if photo.mediumImageURL != "" {
                print("URL for: %@", photo.mediumImageURL)
                self.callFlickrAPI(endpoint: photo.mediumImageURL, photo: photo)
            }
        }
    }
    
    private func callFlickrAPI(endpoint: String, photo: Photo?) {
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
                            photo?.imageSizeDictionary = json
//                            photo?.mediumImageURL = self.getMediumPhotoURL(flickrJsonObject: json)
//                            print(photo?.mediumImageURL)
                            
                            if (photo?.isEqual(self.array.last))! {
                                print("Reached the last object")
                                self.delegate?.didRecieveDictionaryOfPhotoSize(photosArray: self.array)
                            }
//                            self.photoURLsArray.append(self.getPhotoURL(flickrJsonObject: json))
//                            
//                            if self.photoURLsArray.count == self.photosDictionaryArray.count {
//                                self.getImages()
//                            }
                        }
                        if endpoint.range(of: "farm") != nil {
                            print("Calling API")
                            photo?.image = UIImage(data: data!)!
                            
                            if (photo?.isEqual(self.array.last))! {
                                self.delegate?.didRecievePhotos(photosArray: self.array)
                                self.presentlySearching = false
                            }
//                            self.photosArray.append(UIImage(data: data!)!)
//                            
//                            if self.photosArray.count == self.photoURLsArray.count {
//                                self.delegate?.didFetchPhotos(newPhotos: self.photosArray)
//                            }
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
        array.removeAll()
        if let photos = flickrJsonObject["photos"] as? [String:Any] {
            photosDictionaryArray = photos["photo"] as! [[String : Any]]
            
            for photo in photosDictionaryArray {
                let newPhoto = Photo()
                newPhoto.id = photo["id"] as! String
                newPhoto.title = photo["title"] as! String
                array.append(newPhoto)
            }
            delegate?.didRecieveListOfPhotos(photosArray: array)
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
    func didFetchPhotos(newPhotos: [UIImage])
}
