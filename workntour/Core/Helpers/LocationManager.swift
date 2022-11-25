//
//  LocationManager.swift
//  workntour
//
//  Created by Chris Petimezas on 21/6/22.
//

import Foundation
import CoreLocation

struct Location {
    let placemark: PlacemarkAttributes?
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject {
    static let shared = LocationManager()

    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()

    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {

        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }

            let models: [Location] = places.compactMap({ place in

                return Location(placemark: self.locationFormattedName(place), coordinates: place.location?.coordinate)
            })

            completion(models)
        }
    }

    public func fetchPlacemarks(location: CLLocation, completion: @escaping ((PlacemarkAttributes?) -> Void)) {

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }

            completion(self.locationFormattedName(placemark))
        })
    }

    private func locationFormattedName(_ placemark: CLPlacemark) -> PlacemarkAttributes {
        let attributes = PlacemarkAttributes(name: placemark.name, country: placemark.country, area: placemark.administrativeArea, locality: placemark.locality, postalCode: placemark.postalCode)

        return attributes
    }
}
