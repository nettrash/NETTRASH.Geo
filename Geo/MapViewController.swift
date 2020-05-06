//
//  MapViewController.swift
//  Geo
//
//  Created by Иван Алексеев on 15.12.2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController : UIViewController, MKMapViewDelegate {
	
	@IBOutlet var map: MKMapView!

	var points: [MapPoint] = []
	var markers: [MapPoint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Map", comment: "")
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addMark))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController!.navigationBar.titleTextAttributes =
			[NSAttributedString.Key.font:
				UIFont(name: "HelveticaNeue-Bold", size: 28)!,
			 NSAttributedString.Key.foregroundColor: UIColor.lightGray]
		
		self.setupMap()
	}
	
	private func setupMap() {
		self.map.removeAnnotations(self.map.annotations)
		self.map.addAnnotations(points)
		self.map.userTrackingMode = .none
		self.map.isZoomEnabled = true
		self.map.isPitchEnabled = true
		self.map.isRotateEnabled = true
		self.map.isScrollEnabled = true
		self.map.isUserInteractionEnabled = true
		self.map.showsUserLocation = true
		self.map.showsCompass = true
		self.map.showsScale = true
		self.map.showsBuildings = true
		self.map.showsPointsOfInterest = true
		self.map.camera.altitude = 1500
		if (self.points.count > 0) {
			self.map.centerCoordinate = self.points.first!.coordinate
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
				self.map.selectAnnotation(self.points.first!, animated: true)
			}
		}
	}
	
	@objc func addMark() {
		performSegue(withIdentifier: "addmark", sender: self)
	}
		
	//MKMapViewDelegate
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		if annotation is MapPoint {
			var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapPointAnnotationView") as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapPointAnnotationView")
				pinView!.pinTintColor = .green
				pinView!.animatesDrop = true
				pinView!.canShowCallout = true
			} else {
				pinView?.annotation = annotation
			}
			return pinView
		}
		return nil
	}
}
