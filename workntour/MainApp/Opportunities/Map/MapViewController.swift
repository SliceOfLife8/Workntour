//
//  MapViewController.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 21/6/22.
//

import UIKit
import SharedKit
import MapKit
import FloatingPanel
import CommonUI
import EasyTipView

class MapViewController: BaseVC<EmptyViewModel, OpportunitiesCoordinator> {

    private lazy var preferences: EasyTipView.Preferences = {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.scriptFont(.bold, size: 14)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = UIColor.appColor(.purple)
        preferences.drawing.arrowPosition = .top
        return preferences
    }()

    let panel = FloatingPanelController()
    let searchVC = SearchLocationsVC()
    var easyTipView: EasyTipView?

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveBtn: PrimaryButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsCompass = false
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        panel.surfaceView.appearance.cornerRadius = 12
        panel.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mapViewLongPress(_:))))
        easyTipView = EasyTipView(text: "You can either search for a location or select a new one by holding your finger to the map.", preferences: preferences)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.easyTipView?.dismiss()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        easyTipView?.show(forView: saveBtn)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        easyTipView?.dismiss()
    }

    override func setupUI() {
        super.setupUI()

        // Add blur effect on status bar
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.addExclusiveConstraints(superview: view, top: (view.topAnchor, 0), bottom: (view.safeAreaLayoutGuide.topAnchor, 0), left: (view.leadingAnchor, 0), right: (view.trailingAnchor, 0))
    }

    // MARK: - Actions
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .closeMap)
    }

    @IBAction func saveBtnTapped(_ sender: Any) {
        guard let annotation = mapView.annotations.filter({ $0 is MyAnnotation }).first else {
            assertionFailure("This button should be enabled only when an annotation is being presented!")
            return
        }

        self.coordinator?.navigate(to: .saveLocation(name: annotation.subtitle.flatMap { $0 },
                                                     latitude: annotation.coordinate.latitude,
                                                     longitude: annotation.coordinate.longitude))
    }

    @objc func mapViewLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        // Find location of received touch
        let touchPoint = sender.location(in: mapView)
        let wayCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: wayCoords.latitude, longitude: wayCoords.longitude)

        LocationManager.shared.fetchPlacemarks(location: location) { placemarkTitle in
            self.addPin(coordinates: location.coordinate, area: placemarkTitle)
        }
    }

    private func addPin(coordinates: CLLocationCoordinate2D, area: String?) {
        let pin = MyAnnotation(title: "My Opportunity", subtitle: area, coordinate: coordinates)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pin)
        saveBtn.isEnabled = true
    }
}

extension MapViewController: SearchLocationsDelegate, FloatingPanelControllerDelegate, MKMapViewDelegate {
    func findLocation(didSelectLocationWith coordinates: CLLocationCoordinate2D?, area: String?) {
        guard let coordinates = coordinates else { return }
        // Minimize panel & show pin
        panel.move(to: .tip, animated: true)
        addPin(coordinates: coordinates, area: area)

        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }

    func didStartEditing() {
        panel.move(to: .full, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        pinAnnotationView.pinTintColor = .purple
        pinAnnotationView.isDraggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = true

        return pinAnnotationView
    }

    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        if state == .tip {
            searchVC.view.endEditing(true)
        }
    }
}
