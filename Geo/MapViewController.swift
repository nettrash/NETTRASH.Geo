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

class MapViewController : UIViewController {
	
	@IBOutlet var map: MKMapView!
	@IBOutlet var marker: UIView!
	@IBOutlet var markerName: UITextField!
	private var trace: Trace?
	
	var points: [MapPoint] = []
	
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
		self.map.camera.altitude = 1500
		if (self.points.count > 0) {
			self.map.centerCoordinate = self.points.first!.coordinate
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
				self.map.selectAnnotation(self.points.first!, animated: true)
			}
		}
	}
	
	@objc func addMark() {
		self.markerName.attributedPlaceholder = NSAttributedString(
			string: NSLocalizedString("Add marker placeholder", comment: "Add marker placeholder"),
			attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
		)
		
		self.markerName.text = ""
		self.marker.isHidden = false
		self.markerName.becomeFirstResponder()
		
		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let traces = try? moc.fetch(Trace.lastTraceFetchRequest()) as [Trace]
		if (traces?.count ?? 0 > 0) {
			trace = traces?.first
		}
	}
	
	@objc @IBAction func cancelMarker() {
		self.marker.isHidden = true
		self.markerName.resignFirstResponder()
		trace = nil
	}
	
	@objc @IBAction func saveMarker() {
		self.marker.isHidden = true
		self.markerName.resignFirstResponder()

		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let mark = NSEntityDescription.insertNewObject(forEntityName: "Mark", into: moc) as! Mark
		mark.date = trace!.date
		mark.day = trace!.day
		mark.altitudeBAR = trace!.altitudeBAR
		mark.altitudeGPS = trace!.altitudeGPS
		mark.latitude = trace!.latitude
		mark.longitude = trace!.longitude
		mark.pressure = trace!.pressure
		mark.everest = trace!.everest
		mark.name = self.markerName.text ?? "\(NSLocalizedString("MarkName", comment: "MarkName"))  \(trace?.date ?? Date() as NSDate)"
		mark.message = ""
		try? moc.save()
	}
	
}
