//
//  OpportunityDetailsMapCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 5/7/22.
//

import UIKit
import MapKit
import CoreLocation

public class OpportunityDetailsMapCell: UITableViewCell, CLLocationManagerDelegate, MKMapViewDelegate {

    public static let identifier = String(describing: OpportunityDetailsMapCell.self)

    @IBOutlet weak var mapView: MKMapView!

    public override func awakeFromNib() {
        super.awakeFromNib()
        mapView.delegate = self
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }

    public func setupArea(latitude: Double, longitude: Double) {
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.title = "Opportunity"
        annotation.coordinate = coordinates
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)

        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        addRadiusCircle(location: CLLocation(latitude: latitude, longitude: longitude))
    }

    private func addRadiusCircle(location: CLLocation) {
        let circle = MKCircle(center: location.coordinate, radius: 500 as CLLocationDistance)
        mapView.addOverlay(circle)
    }

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor.red.withAlphaComponent(0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}
