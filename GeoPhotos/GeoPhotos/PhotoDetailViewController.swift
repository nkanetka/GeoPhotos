//
//  PhotoDetailViewController.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var id: String!
    var image: UIImage!
    var imageTitle: String!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = imageTitle
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
}
