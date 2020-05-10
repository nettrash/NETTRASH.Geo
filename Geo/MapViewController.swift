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
	var markers: [MapMarkPoint] = []
	
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "markdetail" {
			let dst = segue.destination as! MarkDetailsViewController
			dst.marker = sender as? MapMarkPoint
		}
	}
	
	private func refreshPoints() {
		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let traces: [Dictionary<String, Any>]? = try? moc.fetch(Trace.mapRouteFetchRequest()) as? [Dictionary<String, Any>]
		let grps = Dictionary(grouping: traces!, by: {
			String(format: "%.2f %.2f", $0["latitude"] as! Double, $0["longitude"] as! Double)
		})
		let items = grps.map() {
			$0.value.sorted(by: { (a: [String : Any], b: [String : Any]) -> Bool in
				a["date"] as! Date > b["date"] as! Date
			}).first
		}
		
		map.removeAnnotations(points)
		points.removeAll()
		for element in items {
			print("\(element!["date"] as! Date) \(element!["latitude"] as! Double) \(element!["longitude"] as! Double)")
			points.append(
				MapPoint(
					date: element!["date"] as! Date,
					latitude: element!["latitude"] as! Double,
					longitude: element!["longitude"] as! Double,
					pressure: element!["pressure"] as! Double,
					altitudeBAR: element!["altitudeBAR"] as! Double,
					everest: element!["everest"] as! Double,
					altitudeGPS: element!["altitudeGPS"] as! Double))
		}
		map.addAnnotations(points)
	}
	
	private func refreshMarkers() {
		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let mrkrs: [Mark]? = try? moc.fetch(Mark.fetchRequest()) as? [Mark]
		self.map.removeAnnotations(markers)
		markers.removeAll()
		mrkrs?.sorted(by: { (a: Mark, b: Mark) -> Bool in
			a.date! as Date > b.date! as Date
		}).forEach { m in
			markers.append(
				MapMarkPoint(
					name: m.name,
					message: m.message,
					date: m.date! as Date,
					latitude: m.latitude,
					longitude: m.longitude,
					pressure: m.pressure,
					altitudeBAR: m.altitudeBAR,
					everest: m.everest,
					altitudeGPS: m.altitudeGPS
				)
			)
		}
		self.map.addAnnotations(markers)
	}
	
	private func setupMap() {
		refreshPoints()
		refreshMarkers()
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
		if self.markers.count > 0 {
			self.map.centerCoordinate = self.markers.first!.coordinate
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
				self.map.selectAnnotation(self.markers.first!, animated: true)
			}
		} else if self.points.count > 0 {
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
			let identifier = annotation is MapMarkPoint ? "MapMarkPointAnnotationView" : "MapPointAnnotationView"
			let tintColor: UIColor = annotation is MapMarkPoint ? .systemBlue : .red
			let iconImageName = annotation is MapMarkPoint ? "MapMarkPoint" : "MapPoint"
			var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				pinView!.pinTintColor = tintColor
				pinView!.animatesDrop = true
				pinView!.canShowCallout = true
				pinView!.leftCalloutAccessoryView = UIImageView(image: UIImage(named: iconImageName))
				if annotation is MapMarkPoint {
					let details = UILabel()
					details.numberOfLines = 2
					details.text = (annotation as? MapMarkPoint)?.subtitle
					details.textColor = .lightGray
					details.font = details.font.withSize(13)
					pinView!.detailCalloutAccessoryView = details
					let btnDetails = UIButtonWithTarget(type: UIButton.ButtonType.detailDisclosure)
					btnDetails.setTarget(annotation)
					btnDetails.addTarget(self, action: #selector(showAnnotationDetails), for: .touchUpInside)
					pinView!.rightCalloutAccessoryView = btnDetails
				}
			} else {
				pinView?.annotation = annotation
			}
			return pinView
		}
		return nil
	}
	
	@objc func showAnnotationDetails(_ sender: Any?) {
		let annotation = (sender as? UIButtonWithTarget)?.getTarget() as? MapMarkPoint
		if (annotation != nil) {
			performSegue(withIdentifier: "markdetail", sender: annotation)
		}
	}
}
