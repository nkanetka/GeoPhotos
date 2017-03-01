//
//  PhotoCollectionViewController.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoCollectionViewController: UICollectionViewController, LocationManagerDelegate, ServerHelperDelegate {
    var selectedIndex: Int = -1
    var locations: [CLLocation] = []
//    let notificationCenter = NotificationCenter.default
    var photosArray: [Photo] = []
    var serverHelper: ServerHelper = ServerHelper()
    var locationManager: LocationManager = LocationManager()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverHelper.delegate = self
        locationManager.delegate = self
        locationManager.initialize()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
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
        return photosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GPCollectionViewCellReuseIdentifier, for: indexPath) as! CollectionViewCell
        
        if photosArray.count > 0 {
            let photo: Photo = photosArray[indexPath.item]
            cell.contentView.alpha = 0.0
            cell.photo = photo
            if photo.image == nil {
                photo.checkIfPhotoHasImageLoaded()
            }
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

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
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
        serverHelper.getImagesFor(listOfPhotos: self.photosArray)
    }
    
    func didRecievePhotos(photosArray: [Photo]) {
        self.photosArray.removeAll()
        self.photosArray = photosArray
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func updateCollectionViewPhoto(photoToUpdate: Photo) {
        let index = photosArray.index(of: photoToUpdate)
        let indexPath: IndexPath = IndexPath(index: index!)
        self.collectionView?.reloadItems(at: [indexPath])
    }
}
