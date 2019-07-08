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

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

	private let bar: Barometer = Barometer()
	private let weather: Weather = Weather()
	
	private let locationManager: CLLocationManager = CLLocationManager()
	
	@IBOutlet var tblData: UITableView!
	@IBOutlet var aiLoading: UIActivityIndicatorView!
	
	private var groups: [Int:String] = [:]
	private var items: [Int:[Int:String]] = [:]

	private var barAltitude: Double = 0
	private var barPressure: Double = 0
	private var location: CLLocation? = nil
	
	private var stepLocation: CLLocation? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		
		_initTable()
		_initLocation()
		
		let app = UIApplication.shared.delegate as! AppDelegate
		app.bar!.dataUpdated = refreshAltitudeInfo
	}

	private func _initTable() {
		self.tblData.register(GeoTableViewCell.self, forCellReuseIdentifier: "GeoCell")
		_initGroups()
	}
	
	private func _initLocation() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		let status = CLLocationManager.authorizationStatus()
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			startLocationMonitor()
		} else {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	private func _initGroups() {
		groups[0] = NSLocalizedString("Altitude", comment: "")
		groups[1] = NSLocalizedString("Location", comment: "")
		groups[2] = NSLocalizedString("Pressure", comment: "")
		groups[3] = NSLocalizedString("Weather", comment: "")
		groups[4] = NSLocalizedString("Other", comment: "")
		
		items[0] = [:]
		items[1] = [:]
		items[2] = [:]
		items[3] = [:]
		items[4] = [:]
		
		items[0]![0] = ""
		items[1]![0] = ""
		items[2]![0] = ""
		items[3]![0] = ""
		items[4]![0] = ""

		#if targetEnvironment(simulator)
		
		refreshSimulatorInfo()
		
		#else
		
		self.tblData.reloadData()

		#endif

		self.tblData.isHidden = true
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if locations.count > 0 {
			self.location = locations[locations.count - 1]
			if self.stepLocation == nil {
				self.stepLocation = CLLocation(latitude: self.location!.coordinate.latitude, longitude: self.location!.coordinate.longitude)
				refreshData()
			} else if self.stepLocation!.distance(from: self.location!) > 100.0 { // > 100 m
				self.stepLocation = CLLocation(latitude: self.location!.coordinate.latitude, longitude: self.location!.coordinate.longitude)
				refreshData()
			}
			if self.location != nil {
				//LocationAltitude
				if self.items[0]![0] == nil {
					self.items[0]![0] = "..."
				}
				self.items[0]![1] = String(format: NSLocalizedString("%.0fm according to the GPS/GLONASS", comment: ""), self.location!.altitude)
				
				//Location Latitude
				self.items[1]![0] = String(format: NSLocalizedString("%.6f latitude", comment: ""), self.location!.coordinate.latitude)
				//Location Longitude
				self.items[1]![1] = String(format: NSLocalizedString("%.6f longitude", comment: ""), self.location!.coordinate.longitude)
				self.items[1]![2] = "::actionBar"
			} else {
				self.items[0]![1] = ""
				self.items[1]![0] = ""
				self.items[1]![1] = ""
				self.items[1]![2] = nil
			}
		}
		
		self.tblData.reloadData()
		refreshView()
	}
	
	func refreshView() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.aiLoading.stopAnimating()
			self.tblData.isHidden = false
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .notDetermined { return }
		
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			startLocationMonitor()
		} else {
			if status == .denied {
				stopLocationMonitor()
				let alert = UIAlertController(title: NSLocalizedString("Location", comment: ""), message: NSLocalizedString("The lack of access to the location makes some of the functions of the application unusable", comment: ""), preferredStyle: UIAlertController.Style.actionSheet)
				alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertAction.Style.cancel, handler: { (_ action: UIAlertAction) in
					alert.dismiss(animated: true, completion: nil)
					self.refreshView()
				}))
				self.show(alert, sender: nil)
			}
		}
	}
	
	func startLocationMonitor() {
		locationManager.startUpdatingLocation()
		self.items[0]![1] = ""
	}
	
	func stopLocationMonitor() {
		locationManager.stopUpdatingLocation()
		self.items[0]![1] = ""
	}
	
	#if targetEnvironment(simulator)
	
	func refreshSimulatorInfo() {
		let pressure = 101.325
		let P0: Double = 101.325
		let Ph: Double = 98.768
		let h: Double = log(P0 / Ph) / 0.00012
		let everest = h / 8848
		
		let everestPercent = 100.0 * everest
		let colorDelta = everestPercent * 255.0 / 100.0
		let everestPercentText = String(format: "%.4f", everestPercent)
		let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)
		
		self.barAltitude = h
		self.barPressure = pressure
		//Barometer Altitude
		self.items[0]![0] = String(format: NSLocalizedString("%.0fm according to the barometer", comment: ""), h)
		//Barometer Pressure
		self.items[2]![0] = String(format: NSLocalizedString("%.4f kPa %.4f mm Hg %.4f atm", comment: ""), pressure, pressure * 7.50062, pressure / 101.325)
		//Everest Percent
		self.items[4]![0] = everestPercentText + NSLocalizedString("%🏔 (Everest)", comment: "")

	}
	
	#endif
	
	func refreshAltitudeInfo() {
		let app = UIApplication.shared.delegate as! AppDelegate
		if (app.bar != nil) {
			
			let everestPercent = 100.0 * app.bar!.everest
			let colorDelta = everestPercent * 255.0 / 100.0
			let everestPercentText = String(format: "%.4f", everestPercent)
			let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)

			self.barAltitude = app.bar!.height
			self.barPressure = app.bar!.pressure
			//Barometer Altitude
			self.items[0]![0] = String(format: NSLocalizedString("%.0fm according to the barometer", comment: ""), app.bar!.height)
			//Barometer Pressure
			self.items[2]![0] = String(format: NSLocalizedString("%.4f kPa %.4f mm Hg %.4f atm", comment: ""), app.bar!.pressure, app.bar!.pressure * 7.50062, app.bar!.pressure / 101.325)
			//Everest Percent
			self.items[4]![0] = everestPercentText + NSLocalizedString("%🏔 (Everest)", comment: "")
		} else {
			self.items[0]![0] = ""
			self.items[1]![0] = ""
			self.items[2]![0] = ""
			self.items[4]![0] = ""
		}
		
		self.tblData.reloadData()
		refreshView()
	}
	
	func refreshData() {
		DispatchQueue.main.async {
			self.refreshGeocode()
		}
		DispatchQueue.main.async {
			self.refreshWeather()
		}
	}
	
	func refreshGeocode() {
		let geocode = Geocode(self.stepLocation!)
		if geocode.Response?.response?.GeoObjectCollection?.featureMember?.count ?? 0 > 0 {
			//Geocode Information
			self.items[4]![1] = String(format: "%@", geocode.Response?.response?.GeoObjectCollection?.featureMember?[0].GeoObject?.description ?? "")
		} else {
			self.items[4]![1] = NSLocalizedString("Geocode unavailable", comment: "")
		}
		
		self.tblData.reloadData()
		refreshView()
	}
	
	func refreshWeather() {
		if self.stepLocation == nil { return }
		let result: Any? = weather.Get(api: Weather.WeatherAPI.OpenWeatherMap, coordinate: self.stepLocation!)
		if let response = result as? OpenWeatherMapResponse {
			self.items[3]![0] = response.weatherDetailsTemperature
			self.items[3]![1] = response.weatherDetailsHumidity
			self.items[3]![2] = response.weatherDetailsVisibility
			self.items[3]![3] = response.weatherDetailsWindSpeed
		} else {
			self.items[3]![0] = NSLocalizedString("Weather unavailable", comment: "")
			self.items[3]![1] = nil
			self.items[3]![2] = nil
			self.items[3]![3] = nil
		}
		
		self.tblData.reloadData()
		refreshView()
	}
	
	//UITableViewDelegate

	//UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items[section]?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let value = items[indexPath.section]?[indexPath.row] else {
			return UITableViewCell()
		}
	
		if value == "::actionBar" {
			let cell = tableView.dequeueReusableCell(withIdentifier: "GeoActionCell", for: indexPath) as! GeoActionTableViewCell
			cell.location = self.stepLocation
			cell.viewController = self
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "GeoCell", for: indexPath) as! GeoTableViewCell

		cell.textLabel?.text = value
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return groups.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return groups[section]
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 22
	}
}

