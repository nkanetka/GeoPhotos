//
//  PhotoCollectionViewController.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "CollectionViewCell"

class PhotoCollectionViewController: UICollectionViewController, LocationManagerDelegate, ServerHelperDelegate {
    
    var selectedIndex: Int = -1
    var photos: [UIImage] = []
    var photosInfoDictionary: [[String:Any]] = [[:]]
    
    var photosArray: [Photo] = []
    
    var locations: [CLLocation] = []
    var serverHelper: ServerHelper = ServerHelper()
    var locationManager: LocationManager = LocationManager()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverHelper.delegate = self
        locationManager.delegate = self
        locationManager.initialize()
        locationManager.startUpdatingLocation()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GPShowPhotoDetailSegue" {
            if photosArray.count > 0 {
                let photo: Photo = photosArray[selectedIndex]
                
                let destinationViewController = segue.destination as! PhotoDetailViewController
                destinationViewController.photo = photo
                destinationViewController.currentLocation = locations.last! as CLLocation
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photosArray.count)
        return photosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        if photosArray.count > 0 {
            let photo: Photo = photosArray[indexPath.item]
            cell.contentView.alpha = 0.0
            cell.imageView.image = photo.image
            cell.imageView.contentMode = .scaleAspectFill
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                cell.contentView.alpha = 1.0
            }, completion: nil)
            
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        print("Selected Item")
        performSegue(withIdentifier: "GPShowPhotoDetailSegue", sender: self)
    }

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    // MARK: - LocationManagerDelegate
    func didRecieveLocationUpdate(newLocation: CLLocation) {
        locations.append(newLocation)
        serverHelper.getPhotosFor(coordinate: newLocation.coordinate)
    }
    
    // MARK: - ServerHelperDelegate
    func didRecieveListOfPhotos(photosArray: [Photo]) {
        self.photosArray.removeAll()
        self.photosArray = photosArray
        serverHelper.getDictionaryOfPhotoSizesFor(listOfPhotos: self.photosArray)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func didRecieveDictionaryOfPhotoSize(photosArray: [Photo]) {
        self.photosArray.removeAll()
        self.photosArray = photosArray
        let photo: Photo = self.photosArray[1]
        print(photo.mediumImageURL)
        serverHelper.getImagesFor(listOfPhotos: self.photosArray)
    }
    
    func didRecievePhotos(photosArray: [Photo]) {
        self.photosArray.removeAll()
        self.photosArray = photosArray
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func didFetchPhotos(newPhotos: [UIImage]) {
        photos.removeAll()
        photos = newPhotos
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Methods
    
}
