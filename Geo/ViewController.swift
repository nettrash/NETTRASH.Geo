//
//  ViewController.swift
//  Geo
//
//  Created by Иван Алексеев on 13/05/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

	private let bar: Barometer = Barometer()
	private let locationManager: CLLocationManager = CLLocationManager()
	
	@IBOutlet var lblBarometerAltitude: UILabel!
	@IBOutlet var lblLocationAltitude: UILabel!
	@IBOutlet var lblLocationCoordinatesLatitude: UILabel!
	@IBOutlet var lblLocationCoordinatesLongitude: UILabel!
	@IBOutlet var lblBarometerPressure: UILabel!
	@IBOutlet var lblGeocodeInformation: UILabel!

	private var barAltitude: Double = 0
	private var barPressure: Double = 0
	private var location: CLLocation? = nil
	
	private var stepLocation: CLLocation? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		let status = CLLocationManager.authorizationStatus()
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			startLocationMonitor()
		} else {
			locationManager.requestAlwaysAuthorization()
		}
		
		let app = UIApplication.shared.delegate as! AppDelegate
		app.bar!.dataUpdated = refreshAltitudeInfo
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if locations.count > 0 {
			self.location = locations[locations.count - 1]
			if self.stepLocation == nil {
				self.stepLocation = CLLocation(latitude: self.location!.coordinate.latitude, longitude: self.location!.coordinate.longitude)
				refreshGeocode()
			} else if self.stepLocation!.distance(from: self.location!) > 100.0 { // > 100 m
				self.stepLocation = CLLocation(latitude: self.location!.coordinate.latitude, longitude: self.location!.coordinate.longitude)
				refreshGeocode()
			}
			if self.location != nil {
				self.lblLocationAltitude.text = String(format: "%.0fm according to the GPS/GLONASS", self.location!.altitude)
				self.lblLocationCoordinatesLatitude.text = String(format: "%.6f latitude", self.location!.coordinate.latitude)
				self.lblLocationCoordinatesLongitude.text = String(format: "%.6f longitude", self.location!.coordinate.longitude)
			} else {
				self.lblLocationAltitude.text = ""
				self.lblLocationCoordinatesLatitude.text = ""
				self.lblLocationCoordinatesLongitude.text = ""
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			startLocationMonitor()
		} else {
			if status == .denied {
				manager.requestWhenInUseAuthorization()
			} else {
				stopLocationMonitor()
			}
		}
	}
	
	func startLocationMonitor() {
		locationManager.startUpdatingLocation()
		self.lblLocationAltitude.text = ""
	}
	
	func stopLocationMonitor() {
		locationManager.stopUpdatingLocation()
		self.lblLocationAltitude.text = ""
	}
	
	func refreshAltitudeInfo() {
		let app = UIApplication.shared.delegate as! AppDelegate
		if (app.bar != nil) {
			self.barAltitude = app.bar!.height
			self.barPressure = app.bar!.pressure
			self.lblBarometerAltitude.text = String(format: "%.0fm according to the barometer", app.bar!.height)
			self.lblBarometerPressure.text = String(format: "%.4f kPa %.4f mm Hg %.4f atm", app.bar!.pressure, app.bar!.pressure * 7.50062, app.bar!.pressure / 101.325)
		} else {
			self.lblBarometerAltitude.text = ""
			self.lblBarometerPressure.text = ""
		}
	}
	
	func refreshGeocode() {
		let geocode = Geocode(self.stepLocation!)
		if geocode.Response?.response?.GeoObjectCollection?.featureMember?.count ?? 0 > 0 {
			self.lblGeocodeInformation.text = String(format: "%@", geocode.Response?.response?.GeoObjectCollection?.featureMember?[0].GeoObject?.description ?? "")
		} else {
			self.lblGeocodeInformation.text = "Geocode unavailable"
		}
	}
	
	@IBAction func openInMap() {
		let currentLocationMapItem: MKMapItem = MKMapItem.forCurrentLocation()
		MKMapItem.openMaps(with: [currentLocationMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
	}
}

