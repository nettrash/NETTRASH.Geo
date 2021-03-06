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
import CoreData
import MapKit

class ViewController: UIViewController {

	private let weather: Weather = Weather()
	private let locationManager: CLLocationManager = CLLocationManager()
	private var groups: [Int:String] = [:]
	private var items: [Int:[Int:String]] = [:]
	private var barAltitude: Double = 0
	private var barPressure: Double = 0
	private var location: CLLocation? = nil
	private var stepLocation: CLLocation? = nil
	private var refreshJobs: Int = 0
	
	@IBOutlet var tblData: UITableView!
	@IBOutlet var aiLoading: UIActivityIndicatorView!
	@IBOutlet var toolBar: UIToolbar!

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
	
	private func _initTable() {
		self.tblData.register(GeoTableViewCell.self, forCellReuseIdentifier: "GeoCell")
		_initGroups()
	}

	private func refreshView() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.aiLoading.stopAnimating()
			self.tblData.isHidden = false
			self.toolBar.isHidden = false
		}
	}
	
	private func startLocationMonitor() {
		locationManager.startUpdatingLocation()
		self.items[0]![1] = ""
	}
	
	private func stopLocationMonitor() {
		locationManager.stopUpdatingLocation()
		self.items[0]![1] = ""
	}
	
	private func nearestMountain() -> String? {
		
		guard let loc = self.location else {
			return nil
		}
		let app = UIApplication.shared.delegate as! AppDelegate
		var m: [MountainInfo] = []
		m.append(contentsOf: app.mountainsData?.highest?.mountains ?? [])
		m.append(contentsOf: app.mountainsData?.sevenPeaks?.mountains ?? [])
		m.append(contentsOf: app.mountainsData?.snowLeopardOfRussia?.mountains ?? [])
		if let v = m.min(by: { (a: MountainInfo, b: MountainInfo) -> Bool in
			loc.distance(from: CLLocation(latitude: a.coordinates?.latitude ?? 0, longitude: a.coordinates?.longitude ?? 0)) < loc.distance(from: CLLocation(latitude: b.coordinates?.latitude ?? 0, longitude: b.coordinates?.longitude ?? 0))
		}) {
			return String(format: NSLocalizedString("nearestMountain", comment: ""), loc.distance(from: CLLocation(latitude: v.coordinates?.latitude ?? 0, longitude: v.coordinates?.longitude ?? 0)) / 1000.0, v.name ?? "", v.height ?? 0)
		} else {
			return nil
		}
	}
	
	private func highestDistance() -> String? {
		guard let loc = self.location else {
			return nil
		}
		let app = UIApplication.shared.delegate as! AppDelegate
		guard let highest = app.mountainsData?.highest?.mountains?.first else {
			return nil
		}
		let distance = loc.distance(from: CLLocation(latitude: highest.coordinates?.latitude ?? 0, longitude: highest.coordinates?.longitude ?? 0))
		return String(format: NSLocalizedString("highestMountain", comment: ""), distance / 1000.0, highest.name!, highest.height!)
	}
	
	#if targetEnvironment(simulator)
	
	private func refreshSimulatorInfo() {
		let pressure = 101.325
		let P0: Double = 101.325
		let Ph: Double = 98.768
		let h: Double = log(P0 / Ph) / 0.00012
		let everest = h / 8848
		
		let everestPercent = 100.0 * everest
		//let colorDelta = everestPercent * 255.0 / 100.0
		let everestPercentText = String(format: "%.4f", everestPercent)
		//let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)
		
		self.barAltitude = h
		self.barPressure = pressure
		//Barometer Altitude
		self.items[0]![0] = String(format: NSLocalizedString("%.0fm according to the barometer", comment: ""), h)
		self.items[0]![1] = String(format: NSLocalizedString("%.0fm according to the GPS/GLONASS", comment: ""), h)
		//Barometer Pressure
		self.items[2]![0] = String(format: NSLocalizedString("%.4f kPa %.4f mm Hg %.4f atm", comment: ""), pressure, pressure * 7.50062, pressure / 101.325)
		//Everest Percent
		self.items[4]![0] = everestPercentText + NSLocalizedString("%🏔 (Everest)", comment: "")

		self.tblData.reloadData()
		traceSimulator()
		refreshView()
	}
	
	#endif
		
	@objc
	private func refreshNow(_ sender: Any?) {
		refreshData()
	}
	
	private func refreshData() {
		refreshJobs = 2
		DispatchQueue.global().async {
			self.refreshGeocode()
		}
		DispatchQueue.global().async {
			self.refreshWeather()
		}
	}
	
	private func refreshGeocode() {
		if self.stepLocation != nil {
			let geocoder = CLGeocoder()
			geocoder.reverseGeocodeLocation(self.stepLocation!) { (marks: [CLPlacemark]?, error: Error?) in
				var address: String = ""
				if (marks?.count ?? 0) > 0 {
					let mark = marks![0]
					var parts: [String] = []
					if mark.isoCountryCode != nil {
						parts.append(mark.isoCountryCode!)
					}
					if mark.postalCode != nil {
						parts.append(mark.postalCode!)
					}
					if mark.subThoroughfare != nil {
						parts.append(mark.subThoroughfare!)
					}
					if mark.thoroughfare != nil {
						parts.append(mark.thoroughfare!)
					}
					if mark.subLocality != nil {
						parts.append(mark.subLocality!)
					}
					if mark.locality != nil {
						parts.append(mark.locality!)
					}
					if mark.country != nil {
						parts.append(mark.country!)
					}
					if mark.inlandWater != nil {
						parts.append(mark.inlandWater!)
					}
					if mark.ocean != nil {
						parts.append(mark.ocean!)
					}
					address = parts.joined(separator: ", ")
				} else {
					address = NSLocalizedString("Geocode unavailable", comment: "")
				}
				self.items[4]![1] = String(format: "%@", address)
				DispatchQueue.main.async {
					self.tblData.reloadData()
					self.refreshView()
				}
			}
			/*let geocode = Geocode(self.stepLocation!)
			if geocode.Response?.response?.GeoObjectCollection?.featureMember?.count ?? 0 > 0 {
				//Geocode Information
				self.items[4]![1] = String(format: "%@", 	geocode.Response?.response?.GeoObjectCollection?.featureMember?[0].GeoObject?.description ?? "")
			} else {
				self.items[4]![1] = NSLocalizedString("Geocode unavailable", comment: "")
			}*/
		} else {
			self.items[4]![1] = NSLocalizedString("Geocode unavailable", comment: "")
			self.tblData.reloadData()
			refreshView()
		}
		//self.tblData.reloadData()
		//refreshView()
		refreshJobs = refreshJobs - 1
		if refreshJobs <= 0 {
			DispatchQueue.main.async {
				self.tblData.refreshControl?.endRefreshing()
			}
		}
	}
	
	private func refreshWeather() {
		if self.stepLocation == nil { return }
		let result: Any? = weather.Get(api: Weather.WeatherAPI.OpenWeatherMap, coordinate: self.stepLocation!)
		if let response = result as? OpenWeatherMapResponse {
			self.items[3]![0] = response.weatherDetailsTemperature
			self.items[3]![1] = response.weatherDetailsHumidity
			self.items[3]![2] = response.weatherDetailsVisibility
			self.items[3]![3] = response.weatherDetailsWindSpeed
			self.items[3]![4] = response.weatherDetailsWindDirection
		} else {
			self.items[3]![0] = NSLocalizedString("Weather unavailable", comment: "")
			self.items[3]![1] = nil
			self.items[3]![2] = nil
			self.items[3]![3] = nil
			self.items[3]![4] = nil
		}
		
		DispatchQueue.main.async {
			self.tblData.reloadData()
			self.refreshView()
		}
		
		refreshJobs = refreshJobs - 1
		if refreshJobs <= 0 {
			DispatchQueue.main.async {
				self.tblData.refreshControl?.endRefreshing()
			}
		}
	}

	// TRACE
	
	private func traceLocation() {
		let app = UIApplication.shared.delegate as! AppDelegate
		if (self.location != nil) {
			var everestPercent: Double = 0
			if (app.bar != nil) {
				everestPercent = 100.0 * app.bar!.everest
				if everestPercent == 0 {
					everestPercent = 100.0 * self.location!.altitude / 8848
				}
			}
			
			let moc = app.persistentContainer.viewContext
			let traces = try? moc.fetch(Trace.fetchRequest()) as [Trace]
			
			if (traces != nil) {
				var lastTrace: Trace? = nil
				if traces!.count > 0 { lastTrace = traces![traces!.count-1] }
				var date = Date()
				let calendar = Calendar.current
				var minute = calendar.component(.minute, from: date)
				var second = calendar.component(.second, from: date)
				var nanosecond = calendar.component(.nanosecond, from: date)
				var minuteDelta = minute - 10 * (minute / 10)
				date = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: date)!
				date = calendar.date(byAdding: .second, value: -second, to: date)!
				date = calendar.date(byAdding: .minute, value: -minuteDelta, to: date)!
				
				var d = Date()
				let hour = calendar.component(.hour, from: d)
				minute = calendar.component(.minute, from: d)
				second = calendar.component(.second, from: d)
				nanosecond = calendar.component(.nanosecond, from: d)
				minuteDelta = minute - 10 * (minute / 10)
				d = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: d)!
				d = calendar.date(byAdding: .second, value: -second, to: d)!
				d = calendar.date(byAdding: .minute, value: -minute, to: d)!
				d = calendar.date(byAdding: .hour, value: -hour, to: d)!
				
				var mDiff = 0
				if lastTrace != nil && lastTrace!.date != nil {
					let diff = calendar.dateComponents([.minute], from: lastTrace!.date! as Date, to: date)
					mDiff = diff.minute!
				}
				if lastTrace != nil && lastTrace?.date != nil && lastTrace!.date! as Date == date {
					lastTrace!.latitude = self.location!.coordinate.latitude
					lastTrace!.longitude = self.location!.coordinate.longitude
					lastTrace!.altitudeGPS = self.location!.altitude
					lastTrace!.everest = everestPercent
					try? moc.save()
				} else if minuteDelta == 0 || mDiff > 9 || lastTrace == nil {
					let trace = NSEntityDescription.insertNewObject(forEntityName: "Trace", into: moc) as! Trace
					trace.date = date as NSDate
					trace.day = d as NSDate
					trace.latitude = self.location!.coordinate.latitude
					trace.longitude = self.location!.coordinate.longitude
					trace.altitudeGPS = self.location!.altitude
					trace.everest = everestPercent
					try? moc.save()
				}
				
				if traces!.count > 10000 {
					moc.delete(traces![0])
					try? moc.save()
				}
			}
		}
	}
	
	#if targetEnvironment(simulator)
	
	private func traceSimulator() {
		let pressure = 101.325
		let P0: Double = 101.325
		let Ph: Double = 98.768
		let h: Double = log(P0 / Ph) / 0.00012
		let everest = h / 8848
		
		let everestPercent = 100.0 * everest
		
		self.barAltitude = h
		self.barPressure = pressure

		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let traces = try? moc.fetch(Trace.fetchRequest()) as [Trace]
		
		if (traces != nil) {
			var lastTrace: Trace? = nil
			if traces!.count > 0 { lastTrace = traces![traces!.count-1] }
			var date = Date()
			let calendar = Calendar.current
			var minute = calendar.component(.minute, from: date)
			var second = calendar.component(.second, from: date)
			var nanosecond = calendar.component(.nanosecond, from: date)
			var minuteDelta = minute - 10 * (minute / 10)
			date = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: date)!
			date = calendar.date(byAdding: .second, value: -second, to: date)!
			date = calendar.date(byAdding: .minute, value: -minuteDelta, to: date)!
			
			var d = Date()
			let hour = calendar.component(.hour, from: d)
			minute = calendar.component(.minute, from: d)
			second = calendar.component(.second, from: d)
			nanosecond = calendar.component(.nanosecond, from: d)
			minuteDelta = minute - 10 * (minute / 10)
			d = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: d)!
			d = calendar.date(byAdding: .second, value: -second, to: d)!
			d = calendar.date(byAdding: .minute, value: -minute, to: d)!
			d = calendar.date(byAdding: .hour, value: -hour, to: d)!
			
			var mDiff = 0
			if lastTrace != nil && lastTrace!.date != nil {
				let diff = calendar.dateComponents([.minute], from: lastTrace!.date! as Date, to: date)
				mDiff = diff.minute!
			}
			if lastTrace != nil && lastTrace!.date != nil && lastTrace!.date! as Date == date {
				lastTrace!.altitudeBAR = self.barAltitude
				lastTrace!.pressure = self.barPressure
				lastTrace!.everest = everestPercent
				try? moc.save()
			} else if minuteDelta == 0 || mDiff > 9 || lastTrace == nil {
				let trace = NSEntityDescription.insertNewObject(forEntityName: "Trace", into: moc) as! Trace
				trace.date = date as NSDate
				trace.day = d as NSDate
				trace.altitudeBAR = self.barAltitude
				trace.pressure = self.barPressure
				trace.everest = everestPercent
				try? moc.save()
			}
			
			if traces!.count > 10000 {
				moc.delete(traces![0])
				try? moc.save()
			}
		}
	}
	
	#endif
	
	private func traceBarometer() {
		let app = UIApplication.shared.delegate as! AppDelegate
		if (app.bar != nil) {
			
			var everestPercent = 100.0 * app.bar!.everest
			if everestPercent == 0 && self.stepLocation != nil {
				everestPercent = 100.0 * self.stepLocation!.altitude / 8848
			}
			self.barAltitude = app.bar!.height
			self.barPressure = app.bar!.pressure
			
			let moc = app.persistentContainer.viewContext
			let traces = try? moc.fetch(Trace.fetchRequest()) as [Trace]
			
			if (traces != nil) {
				var lastTrace: Trace? = nil
				if traces!.count > 0 { lastTrace = traces![traces!.count-1] }
				var date = Date()
				let calendar = Calendar.current
				var minute = calendar.component(.minute, from: date)
				var second = calendar.component(.second, from: date)
				var nanosecond = calendar.component(.nanosecond, from: date)
				var minuteDelta = minute - 10 * (minute / 10)
				date = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: date)!
				date = calendar.date(byAdding: .second, value: -second, to: date)!
				date = calendar.date(byAdding: .minute, value: -minuteDelta, to: date)!
				
				var d = Date()
				let hour = calendar.component(.hour, from: d)
				minute = calendar.component(.minute, from: d)
				second = calendar.component(.second, from: d)
				nanosecond = calendar.component(.nanosecond, from: d)
				minuteDelta = minute - 10 * (minute / 10)
				d = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: d)!
				d = calendar.date(byAdding: .second, value: -second, to: d)!
				d = calendar.date(byAdding: .minute, value: -minute, to: d)!
				d = calendar.date(byAdding: .hour, value: -hour, to: d)!
				
				var mDiff = 0
				if lastTrace != nil && lastTrace!.date != nil {
					let diff = calendar.dateComponents([.minute], from: lastTrace!.date! as Date, to: date)
					mDiff = diff.minute!
				}
				if lastTrace != nil && lastTrace!.date != nil && lastTrace!.date! as Date == date {
					lastTrace!.altitudeBAR = self.barAltitude
					lastTrace!.pressure = self.barPressure
					lastTrace!.everest = everestPercent
					try? moc.save()
				} else if minuteDelta == 0 || mDiff > 9 || lastTrace == nil {
					let trace = NSEntityDescription.insertNewObject(forEntityName: "Trace", into: moc) as! Trace
					trace.date = date as NSDate
					trace.day = d as NSDate
					trace.altitudeBAR = self.barAltitude
					trace.pressure = self.barPressure
					trace.everest = everestPercent
					try? moc.save()
				}
				
				if traces!.count > 10000 {
					moc.delete(traces![0])
					try? moc.save()
				}
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		_initTable()
		_initLocation()
		
		let app = UIApplication.shared.delegate as! AppDelegate
		app.bar!.dataUpdated = refreshAltitudeInfo
		
		title = NSLocalizedString("NETTRASH.Geo", comment: "")

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addMark))
		
		#if !targetEnvironment(simulator)
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshNow), for: UIControl.Event.valueChanged)
		tblData.refreshControl = refreshControl
		
		#endif
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray]
		
		#if targetEnvironment(simulator)
		
		refreshSimulatorInfo()
		tblData.reloadData()
		
		#endif
	}
		
	@objc func addMark() {
		performSegue(withIdentifier: "addmarkfrommain", sender: self)
	}

	@IBAction @objc func gotoGraph(_ sender: Any?) {
		self.performSegue(withIdentifier: "graph", sender: self)
	}
	
	@IBAction @objc func gotoMap(_ sender: Any?) {
		self.performSegue(withIdentifier: "map", sender: self)
	}

	func refreshAltitudeInfo() {
		let app = UIApplication.shared.delegate as! AppDelegate
		if (app.bar != nil) {
			
			let everestPercent = 100.0 * app.bar!.everest
			//let colorDelta = everestPercent * 255.0 / 100.0
			let everestPercentText = String(format: "%.4f", everestPercent)
			//let everestColor = UIColor(red: CGFloat(colorDelta / 255.0), green: CGFloat((255.0 - colorDelta) / 255.0), blue: 0, alpha: 1)

			self.barAltitude = app.bar!.height
			self.barPressure = app.bar!.pressure
			//Barometer Altitude
			self.items[0]![0] = String(format: NSLocalizedString("%.0fm according to the barometer", comment: ""), app.bar!.height)
			//Barometer Pressure
			self.items[2]![0] = String(format: NSLocalizedString("%.4f kPa %.4f mm Hg %.4f atm", comment: ""), app.bar!.pressure, app.bar!.pressure * 7.50062, app.bar!.pressure / 101.325)
			//Everest Percent
			self.items[4]![0] = everestPercentText + NSLocalizedString("%🏔 (Everest)", comment: "")
			
			traceBarometer();
		} else {
			self.items[0]![0] = ""
			self.items[1]![0] = ""
			self.items[2]![0] = ""
			self.items[4]![0] = ""
			if self.items[4]![0] == "" && self.stepLocation != nil {
				let everest = self.stepLocation!.altitude / 8848
				let everestPercent = 100.0 * everest
				//let colorDelta = everestPercent * 255.0 / 100.0
				let everestPercentText = String(format: "%.4f", everestPercent)
				//Everest Percent
				self.items[4]![0] = everestPercentText + NSLocalizedString("%🏔 (Everest GPS)", comment: "")
			}
		}
		
		self.tblData.reloadData()
		refreshView()
	}

}

extension ViewController: UITableViewDelegate {
	
}

extension ViewController: UITableViewDataSource {

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
		
		if (indexPath.section == 4 && indexPath.row == 1) ||
			(indexPath.section == 1 && indexPath.row == 5) {
			cell.textLabel?.numberOfLines = 0
		} else {
			cell.textLabel?.numberOfLines = 1
		}
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return groups.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return groups[section]
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath.section == 4 && indexPath.row == 1) ||
			(indexPath.section == 1 && indexPath.row == 5) {
			return 44
		}
		return 22
	}
	
}

extension ViewController: CLLocationManagerDelegate {
	
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
				
				if self.items[4]![0] == "" {
					let everest = self.location!.coordinate.longitude / 8848
					let everestPercent = 100.0 * everest
					//let colorDelta = everestPercent * 255.0 / 100.0
					let everestPercentText = String(format: "%.4f", everestPercent)
					//Everest Percent
					self.items[4]![0] = everestPercentText + NSLocalizedString("%🏔 (Everest) GPS", comment: "")
				}
				
				//Location Latitude
				self.items[1]![0] = String(format: NSLocalizedString("%.6f latitude", comment: ""), self.location!.coordinate.latitude)
				//Location Longitude
				self.items[1]![1] = String(format: NSLocalizedString("%.6f longitude", comment: ""), self.location!.coordinate.longitude)
				self.items[1]![2] = "::actionBar"
				self.items[1]![3] = ""
				self.items[1]![4] = nearestMountain()
				self.items[1]![5] = highestDistance()
			} else {
				self.items[0]![1] = ""
				self.items[1]![0] = ""
				self.items[1]![1] = ""
				self.items[1]![2] = nil
				self.items[1]![3] = nil
				self.items[1]![4] = nil
				self.items[1]![5] = nil
			}
			traceLocation();
		}
		
		self.tblData.reloadData()
		refreshView()
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
	
}
