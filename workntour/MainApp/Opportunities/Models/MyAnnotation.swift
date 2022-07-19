//
//  MyAnnotation.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import CoreLocation
import MapKit

struct PlacemarkAttributes: Hashable, Codable {
    let name: String?
    let country: String?
    let area: String?
    let locality: String?
    let postalCode: String?

    func formattedName(userIsHost: Bool?) -> String {
        var attributes = [name, area, locality, country, postalCode]
        let sensitiveDataIndicies: Set = [0, 4]

        if userIsHost == false { // Remove name & postalCode attribute
            attributes = attributes.enumerated()
                .filter { !sensitiveDataIndicies.contains($0.offset) }
                .map { $0.element }
        } else if name == postalCode {
            attributes.removeFirst()
        }

        return attributes.compactMap({ $0 }).map({ String($0) }).joined(separator: ", ")
    }

    func simpleFormat() -> String {
        return [area, country].compactMap({ $0 }).map({ String($0) }).joined(separator: ", ")
    }
}

class MyAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let location: OpportunityLocation
    let coordinate: CLLocationCoordinate2D

    init(title: String?, subtitle: String?, location: OpportunityLocation) {
        self.title = title
        self.subtitle = subtitle
        self.location = location
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
