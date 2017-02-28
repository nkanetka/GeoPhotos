//
//  PhotoDetailViewController.swift
//  GeoPhotos
//
//  Created by Nehal Kanetkar on 2017-02-27.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PhotoDetailViewController: UIViewController, MKMapViewDelegate {
    var photo: Photo!
    let regionRadius: CLLocationDistance = CLLocationDistance(GPMapRegionRadius)
    var currentLocation: CLLocation!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var latLonLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = photo.title
        imageView.image = photo.image
        imageView.contentMode = .scaleAspectFill
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setPhotoPinOnMap() {
        let pin = MKPointAnnotation()
        let photoCoordinate = CLLocationCoordinate2DMake(Double(photo.latitude)!, Double(photo.longitude)!)
        pin.coordinate = photoCoordinate
        mapView.addAnnotation(pin)
    }
    
    func setupView() {
        setLabels()
        mapView.showsUserLocation = true
        if currentLocation != nil {
            centerMapOnLocation(location: currentLocation)
            setPhotoPinOnMap()
        }
    }
    
    func setLabels() {
        cityLabel.text = photo.city
        stateLabel.text = photo.state
        titleLabel.text = photo.title
        countyLabel.text = photo.county
        authorLabel.text = photo.author
        latLonLabel.text = photo.latitude + "/" + photo.longitude
        countyLabel.text = photo.county
        countryLabel.text = photo.country
    }
}
