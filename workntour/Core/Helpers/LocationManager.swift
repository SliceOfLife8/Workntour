//
//  LocationManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 21/6/22.
//

import Foundation
import CoreLocation

struct Location {
    let title: String?
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

                return Location(title: self.locationFormattedName(place), coordinates: place.location?.coordinate)
            })

            completion(models)
        }
    }

    public func fetchPlacemarks(location: CLLocation, completion: @escaping ((String?) -> Void)) {

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }

            completion(self.locationFormattedName(placemark))
        })
    }

    private func locationFormattedName(_ placemark: CLPlacemark) -> String {
        var name = ""
        if let locationName = placemark.name {
            name += locationName
        }

        if let adminRegion = placemark.administrativeArea {
            name += ", \(adminRegion)"
        }

        if let locality = placemark.locality {
            name += ", \(locality)"
        }

        if let country = placemark.country {
            name += ", \(country)"
        }

        if let postalCode = placemark.postalCode {
            name += ", \(postalCode)"
        }

        return name
    }
}
