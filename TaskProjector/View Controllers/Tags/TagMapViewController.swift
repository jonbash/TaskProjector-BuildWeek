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
    var currentLocation: CLLocationCoordinate2D? {
        willSet {
            if editingTag?.location == nil, currentLocation == nil,
                let newLocation = newValue {

                setViewRegion(forLocation: newLocation)
            }
        }
    }
    var editingTag: Tag?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationHelper.delegate = self
        mapView.delegate = self
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: "TagAnnotationView")
        setUpTagLocationSetGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tag = editingTag {
            title = "\"\(tag.name)\" location"
        } else {
            title = "Locations"
        }
        setUpAnnotations()
        setViewRegion()
    }

    // MARK: - Methods

    @objc
    func setTagLocation(_ sender: UIGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchPoint = sender.location(in: mapView)
        let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        do {
            try tagsCoordinator?.setTagLocation(location, tag: editingTag)
        } catch {
            NSLog("Error setting tag location: \(error)")
        }
        setUpAnnotations()
    }

    // MARK: - Setup

    private func setViewRegion(forLocation location: CLLocationCoordinate2D? = nil) {
        guard let location = location ?? editingTag?.location ?? currentLocation
            else { return }
        mapView.setRegion(
            MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.25,
                    longitudeDelta: 0.25)),
            animated: true)
    }

    private func setUpAnnotations() {
        // TODO: make more efficient
        guard let annotations = tagsCoordinator?.tagMapAnnotations else { return }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
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
            let tagAnnotation = annotation as? TagMapAnnotation,
            let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: "TagAnnotationView",
                for: tagAnnotation)
                as? MKMarkerAnnotationView
            else { return nil }
        annotationView.canShowCallout = false // TODO: create callout
        return annotationView
    }
}

// MARK: - LocationHelper Delegate

extension TagMapViewController: LocationHelperDelegate {
    func currentLocationDidChange(to newLocation: CLLocationCoordinate2D) {
        currentLocation = newLocation
    }
}
