//
//  MapOfOpportunitiesVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/7/22.
//

import UIKit
import MapKit
import SharedKit
import Cluster

class MapOfOpportunitiesVC: BaseVC<MapOfOpportunitiesViewModel, HomeCoordinator> {

    // MARK: - Vars
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward.square.fill"), for: .normal)
        button.tintColor = UIColor.appColor(.purple)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()

    private lazy var manager: ClusterManager = { [unowned self] in
        let manager = ClusterManager()
        manager.maxZoomLevel = 17
        manager.minCountForClustering = 3
        manager.clusterPosition = .nearCenter
        return manager
    }()

    private let pin = UIImage(systemName: "house.fill")?.filled(with: .purple)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.getOpportunitiesCoordsByLocation()
    }

    override func setupUI() {
        super.setupUI()

        view.addSubview(mapView)
        view.addSubview(backButton)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }

        // Add blur effect on status bar
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        mapView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$opportunitiesCoordinates
            .dropFirst()
            .sink(receiveValue: { [weak self] models in
                if models.count == 0 {
                    self?.coordinator?.navigate(to: .state(.showAlert(title: "Unable to retrieve locations", subtitle: "Something went wrong with our service.\nPlease try again!")))
                } else {
                    self?.addAnnotations(models)
                }
            })
            .store(in: &storage)
    }

    private func addAnnotations(_ locations: [OpportunityCoordinateModel]) {
        var annotations = [MKAnnotation]()

        locations.forEach { location in
            let coordinate =  CLLocationCoordinate2D(latitude:
                                                        location.latitude,
                                                     longitude: location.longitude)
            let annotation = Annotation(__coordinate: coordinate,
                                        title: "Opportunity",
                                        subtitle: location.id)

            annotations.append(annotation)
        }

        manager.add(annotations)
        manager.reload(mapView: mapView)
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        self.coordinator?.navigator.popViewController(animated: true)
    }
}

// MARK: - MKMapView Delegate
extension MapOfOpportunitiesVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            return mapView.annotationView(annotation: annotation, reuseIdentifier: "ClusterAnnotation")
        } else {
            let identifier = "Pin"
            let annotationView = mapView.annotationView(of: MKPinAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = pin
            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        mapView.deselectAnnotation(annotation, animated: false)

        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x,
                                          y: annotationPoint.y,
                                          width: 0,
                                          height: 0)

                zoomRect = zoomRect.isNull ? pointRect : zoomRect.union(pointRect)
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else if let opportunityAnnotation = annotation as? Annotation {
            guard let opportunityId = opportunityAnnotation.subtitle else {
                return
            }

            self.coordinator?.navigate(to: .showDetails(opportunityId, animated: false))
        }
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }

}

extension MKMapView {
    func annotationView(annotation: MKAnnotation?, reuseIdentifier: String) -> MKAnnotationView {
        let annotationView = annotationView(of: CountClusterAnnotationView.self,
                                            annotation: annotation,
                                            reuseIdentifier: reuseIdentifier)
        annotationView.countLabel.backgroundColor = UIColor.appColor(.purple)
        return annotationView
    }
}
