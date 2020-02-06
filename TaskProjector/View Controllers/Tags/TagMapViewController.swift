//
//  TagMapViewController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-05.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import MapKit

class TagMapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    var userAnnotation: MKAnnotationView?

    weak var tagsCoordinator: TagsCoordinator?
    var locationHelper = LocationHelper()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: "TagAnnotationView")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnnotations()
    }

    // MARK: - Methods

    @objc
    func setTagLocation(_ sender: UIGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchPoint = sender.location(in: mapView)
        let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        do {
            try tagsCoordinator?.setLocation(location)
        } catch {
            NSLog("Error setting tag location: \(error)")
        }
    }

    // MARK: - Setup

    private func setUpAnnotations() {
        guard let annotations = tagsCoordinator?.tagMapAnnotations else { return }
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)

        guard let location = locationHelper.currentLocation else { return }
        mapView.setRegion(
            MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(
                    latitudeDelta: 2,
                    longitudeDelta: 2)),
            animated: true)
    }

    private func setUpTagLocationSetGesture() {
        let tagSetGesture = UILongPressGestureRecognizer()
        tagSetGesture.minimumPressDuration = 1
        tagSetGesture.addTarget(self, action: #selector(setTagLocation(_:)))
        mapView.addGestureRecognizer(tagSetGesture)
    }
}

// MARK: - MapView Delegate

extension TagMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        guard
            let tagAnnotation = annotation as? Tag.MapAnnotation,
            let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: "TagAnnotationView",
                for: tagAnnotation)
                as? MKMarkerAnnotationView
            else { return nil }
        annotationView.canShowCallout = false // TODO: create callout
        return annotationView
    }
}
