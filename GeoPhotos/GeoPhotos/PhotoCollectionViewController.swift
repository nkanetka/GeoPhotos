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

class PhotoCollectionViewController: UICollectionViewController, LocationManagerDelegate {
    
    var locations: [CLLocation] = []
    var serverHelper: ServerHelper = ServerHelper()
    var locationManager: LocationManager = LocationManager()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.initialize()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // FIXME: Move to proper location
        locationManager.startUpdatingLocation()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
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

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    // MARK: - LocationManagerDelegate
    func didRecieveLocationUpdate(newLocation: CLLocation) {
        locations.append(newLocation)
        serverHelper.getPhotosFor(coordinate: newLocation.coordinate)
        print("Location Update Recieved PhotoCollectionViewController")
    }
    
    // MARK: - Methods
    
}
