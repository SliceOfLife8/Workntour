//
//  MyAnnotation.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/6/22.
//

import CoreLocation
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
