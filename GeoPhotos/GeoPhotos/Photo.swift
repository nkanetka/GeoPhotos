//
//  Photo.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-28.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var id: String!
    var title: String!
    var image: UIImage!
    var mediumImageURL: String = "" {
        willSet(newValue) {
//            print(newValue)
        }
    }
    var imageSizeDictionary: [String:Any] = [:] {
        willSet(newDictionary) {
//            print("will set")
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
