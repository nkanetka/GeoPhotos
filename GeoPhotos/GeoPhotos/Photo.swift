//
//  Photo.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-28.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var id: String! {
        didSet {
            DispatchQueue.global(qos: .background).async {
                print("calling api")
                let endpoint = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=071eff2e09e1cbf89789d8675c28d817&photo_id=" + self.id + "&format=json&nojsoncallback=1"
                func getPhotoData(endpoint: String) {
                    var request = URLRequest(url: URL(string: endpoint)!)
                    let session = URLSession.shared
                    request.httpMethod = "GET"
                    
                    let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                        if error == nil {
                            if let httpResponse = response as? HTTPURLResponse {
                                switch httpResponse.statusCode {
                                case 200:
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                                        self.photoDataDictionary = json!
                                    }
                                    catch {
                                        print("---- Error Serializing JSON Object From Flickr API ----")
                                        self.photoDataDictionary = ["":""]
                                    }
                                default:
                                    self.photoDataDictionary = ["":""]
                                }
                            }
                        }
                    })
                    task.resume()
                }
            }
        }
    }
    var title: String!
    var image: UIImage!
    var mediumImageURL: String = ""
    var photoDataDictionary: [String:Any] = [:]
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
}
