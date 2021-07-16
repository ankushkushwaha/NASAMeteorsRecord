//
//  MapViewController.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var meteorViewModel: MeteorViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let coordinates = meteorViewModel?.location,
           let lat = coordinates.last,
           let long = coordinates.first {

            let annotation = MKPointAnnotation()
                let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            annotation.coordinate = centerCoordinate

            var detailText = ""
            if let name = meteorViewModel?.name {

                detailText = name
            }
            if let mass = meteorViewModel?.mass {

                detailText += "\nMass: \(mass)"
            }
            if let year = meteorViewModel?.year {
                detailText += "\nDate: \(year)"
            }

            annotation.title = detailText

            mapView.addAnnotation(annotation)

            mapView.setCenter(centerCoordinate, animated: true)
        }

    }

}
