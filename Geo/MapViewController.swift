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

class MapViewController : UIViewController {
	
	@IBOutlet var map: MKMapView!
	
	var points: [MapPoint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Map", comment: "")
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
}
