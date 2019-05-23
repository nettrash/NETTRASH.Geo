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

class ViewController: UIViewController, CLLocationManagerDelegate {

	var barometerManager: CMAltimeter? = nil
	var locationManager: CLLocationManager? = nil
	var isLocationEnabled: Bool = false
	var barH: Double = 0
	var locH: Double = 0
	var barPressure: Double = 0
	var barDeltaH: Double = 0
	
	@IBOutlet var lblResult: UILabel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if CMAltimeter.isRelativeAltitudeAvailable() {
			// Do any additional setup after loading the view.
			barometerManager = CMAltimeter()
			barometerManager?.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data: CMAltitudeData?
				, error: Error?) in
				if data != nil {
					self.barPressure = data!.pressure.doubleValue
					self.barDeltaH = data!.relativeAltitude.doubleValue
					//h = k*T*ln(P0/Ph)/(m*g)
					//P0 = 101325 Па
					//g = 9.8 м/с^2
					//k = 1.38*10^-23 Дж/К
					//m = 4,817*10^-26 кг
					//Ph = data!.preassure * 1000
					//T - температура 293 K = 20 C
					let T: Double = 296
					let P0: Double = 101325
					let g: Double = 9.8
					let k: Double = 1.38 * pow(10, -23)
					let m: Double = 4.817 * pow(10, -26)
					let Ph: Double = data!.pressure.doubleValue * Double(1000)
					let h: Double = k * T * log(P0 / Ph) / ( m * g )
					
					self.barH = h
					self.refreshAltitudeInfo()
				}
			})
		} else {
			NSLog("not supported barometer")
		}
		
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		let status = CLLocationManager.authorizationStatus()
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			startLocationMonitor()
		} else {
			locationManager?.requestAlwaysAuthorization()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if locations.count > 0 {
			locH = locations[locations.count - 1].altitude
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
		isLocationEnabled = true
		locationManager?.startUpdatingLocation()
	}
	
	func stopLocationMonitor() {
		isLocationEnabled = false
		locationManager?.stopUpdatingLocation()
	}
	
	func refreshAltitudeInfo() {
		NSLog("barH \(barH) barPressure \(barPressure) barRelativeH \(barDeltaH) locH \(locH)")
		if isLocationEnabled {
			self.lblResult?.text = String(format: "%.0f m", locH + barDeltaH)
		} else {
			self.lblResult?.text = String(format: "%.0f m (293K)", barH)
		}
	}
}

