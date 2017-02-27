//
//  ServerHelper.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import Foundation
import CoreLocation

class ServerHelper: NSObject {
    
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
    
    private func callFlickrAPI(endpoint: String) {
        var request = URLRequest(url: URL(string: endpoint)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        self.parseData(data: data!)
                    default:
                        print("Error calling API")
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
    
    func parseData(data: Data) {
        let jsonOptions: JSONSerialization.ReadingOptions = []
        
        print(data)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: jsonOptions) as? [String:Any]
            print(json ?? ["Error":"Error"])
        }
        catch {
            print("---- Error Serializing JSON Object From Flickr API ----")
        }
    }
}
