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
	
	private enum SettingsState {
        case collapsed
        case expanded
    }
	
	private var nextState: SettingsState {
        return settingsVisible ? .collapsed : .expanded
    }
    private var settingsViewController: MapSetupViewController!
    private var visualEffectView: UIVisualEffectView!
    private var endSettingsHeight: CGFloat = 0
    private var startSettingsHeight: CGFloat = 0
    private var settingsVisible = false
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0
	private var points: [MapPoint] = []
	private var markers: [MapMarkPoint] = []
	private var mountainsHighest100: [MapMountainPoint] = []
	private var mountains7Peaks: [MapMountainPoint] = []
	private var mountainsSnowLeopardRussia: [MapMountainPoint] = []

	@IBOutlet var map: MKMapView!
	
	private func refreshPoints() {
		let app = UIApplication.shared.delegate as! AppDelegate
		let moc = app.persistentContainer.viewContext
		let traces: [Dictionary<String, Any>]? = try? moc.fetch(Trace.mapRouteFetchRequest()) as? [Dictionary<String, Any>]
		let grps = Dictionary(grouping: traces!, by: {
			String(format: "%.2f %.2f", $0["latitude"] as! Double, $0["longitude"] as! Double)
		})
		let items = grps
			.map() {
				$0.value.sorted(by: { (a: [String : Any], b: [String : Any]) -> Bool in
					a["date"] as! Date > b["date"] as! Date
				}).first
			}
			.sorted(by: { (a: [String : Any]?, b: [String : Any]?) -> Bool in
				a!["date"] as! Date > b!["date"] as! Date
			})
		
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
		if UserDefaults.standard.bool(forKey: "showPoints", default: true) {
			map.addAnnotations(points)
		}
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
		if UserDefaults.standard.bool(forKey: "showMarkers", default: true) {
			self.map.addAnnotations(markers)
		}
	}
	
	private func refreshMountains() {
		self.map.removeAnnotations(mountainsHighest100)
		self.map.removeAnnotations(mountains7Peaks)
		self.map.removeAnnotations(mountainsSnowLeopardRussia)
		mountainsHighest100.removeAll()
		mountains7Peaks.removeAll()
		mountainsSnowLeopardRussia.removeAll()

		let app = UIApplication.shared.delegate as! AppDelegate
				
		if UserDefaults.standard.bool(forKey: "showHighest", default: true) {
			mountainsHighest100 = app.mountainsData!.highest!.mountains!.sorted(by: { (a: MountainInfo, b: MountainInfo) -> Bool in
				a.position ?? 0 < b.position ?? 0
			}).map({ (m: MountainInfo) -> MapMountainPoint in
				MapMountainPoint(mountain: m, type: .HIGHEST)
			})

			self.map.addAnnotations(mountainsHighest100)
		}
		if UserDefaults.standard.bool(forKey: "showSevenPeaks", default: true) {
			mountains7Peaks = app.mountainsData!.sevenPeaks!.mountains!.sorted(by: { (a: MountainInfo, b: MountainInfo) -> Bool in
				a.position ?? 0 < b.position ?? 0
			}).map({ (m: MountainInfo) -> MapMountainPoint in
				MapMountainPoint(mountain: m, type: .SEVEN_PEAKS)
			})
			
			self.map.addAnnotations(mountains7Peaks)
		}
		if UserDefaults.standard.bool(forKey: "showSnowLeopardRussia", default: true) {
			mountainsSnowLeopardRussia = app.mountainsData!.snowLeopardOfRussia!.mountains!.sorted(by: { (a: MountainInfo, b: MountainInfo) -> Bool in
				a.position ?? 0 < b.position ?? 0
			}).map({ (m: MountainInfo) -> MapMountainPoint in
				MapMountainPoint(mountain: m, type: .SNOW_LEOPARD_OF_RUSSIA)
			})
			
			self.map.addAnnotations(mountainsSnowLeopardRussia)
		}
	}
	
	private func setupMap() {
		refreshPoints()
		refreshMarkers()
		refreshMountains()
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
		if self.points.count > 0 {
			self.map.centerCoordinate = self.points.first!.coordinate
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
				self.map.selectAnnotation(self.points.first!, animated: true)
			}
		}
	}

	private func setupSettings() {
        endSettingsHeight = 400//self.view.frame.height * 0.7
        startSettingsHeight = 100//self.view.frame.height * 0.3
        
		let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
		guard let svc = storyboard.instantiateViewController(withIdentifier: "MapSetupViewController") as? MapSetupViewController else {
			return
		}
		settingsViewController = svc
		
        visualEffectView = UIVisualEffectView()
		visualEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(visualEffectView)
		visualEffectView.isUserInteractionEnabled = false
		self.view.addSubview(settingsViewController.view)
		
        settingsViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - startSettingsHeight, width: self.view.bounds.width, height: endSettingsHeight + 200)
        settingsViewController.view.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleSettingsTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.handleSettingsPan(recognizer:)))

        settingsViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        settingsViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
		settingsViewController.switchPoints.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
		settingsViewController.switchMarkers.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
		settingsViewController.switchHighest.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
		settingsViewController.switchSevenPeaks.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
		settingsViewController.switchSnowLeopard.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
		
		loadSettings()
	}

	private func animateTransitionIfNeeded (state: SettingsState, duration: TimeInterval) {
		if runningAnimations.isEmpty {
			let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
				switch state {
				case .expanded:
					self.settingsViewController.view.frame.origin.y = self.view.frame.height - self.endSettingsHeight
					self.visualEffectView.effect = UIBlurEffect(style: .dark)
					self.visualEffectView.isUserInteractionEnabled = true
				case .collapsed:
					self.settingsViewController.view.frame.origin.y = self.view.frame.height - self.startSettingsHeight
					self.visualEffectView.effect = nil
					self.visualEffectView.isUserInteractionEnabled = false
				}
			}
			 
			frameAnimator.addCompletion { _ in
				self.settingsVisible = !self.settingsVisible
				self.runningAnimations.removeAll()
			}
			 
			frameAnimator.startAnimation()
			 
			runningAnimations.append(frameAnimator)
			 
			let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
				switch state {
				case .expanded:
					self.settingsViewController.view.layer.cornerRadius = 20
					 
				case .collapsed:
					self.settingsViewController.view.layer.cornerRadius = 0
				}
			}
			 
			cornerRadiusAnimator.startAnimation()
			 
			runningAnimations.append(cornerRadiusAnimator)
			 
		}
	}
	 
	private func startInteractiveTransition(state: SettingsState, duration: TimeInterval) {
		 
		if runningAnimations.isEmpty {
			animateTransitionIfNeeded(state: state, duration: duration)
		}
		 
		for animator in runningAnimations {
			animator.pauseAnimation()
			animationProgressWhenInterrupted = animator.fractionComplete
		}
	}
	 
	private func updateInteractiveTransition(fractionCompleted:CGFloat) {
		for animator in runningAnimations {
			animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
		}
	}
	 
	private func continueInteractiveTransition (){
		for animator in runningAnimations {
			animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		}
	}
	
	private func loadSettings() {
		UserDefaults.standard.synchronize()
		settingsViewController.switchPoints.isOn = UserDefaults.standard.bool(forKey: "showPoints", default: true)
		settingsViewController.switchMarkers.isOn = UserDefaults.standard.bool(forKey: "showMarkers", default: true)
		settingsViewController.switchHighest.isOn = UserDefaults.standard.bool(forKey: "showHighest", default: true)
		settingsViewController.switchSevenPeaks.isOn = UserDefaults.standard.bool(forKey: "showSevenPeaks", default: true)
		settingsViewController.switchSnowLeopard.isOn = UserDefaults.standard.bool(forKey: "showSnowLeopardRussia", default: true)
	}
	
	private func saveSettings() {
		UserDefaults.standard.synchronize()
		UserDefaults.standard.set(settingsViewController.switchPoints.isOn, forKey: "showPoints")
		UserDefaults.standard.set(settingsViewController.switchMarkers.isOn, forKey: "showMarkers")
		UserDefaults.standard.set(settingsViewController.switchHighest.isOn, forKey: "showHighest")
		UserDefaults.standard.set(settingsViewController.switchSevenPeaks.isOn, forKey: "showSevenPeaks")
		UserDefaults.standard.set(settingsViewController.switchSnowLeopard.isOn, forKey: "showSnowLeopardRussia")
		UserDefaults.standard.synchronize()
	}
	
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
		self.setupSettings()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "markdetail" {
			let dst = segue.destination as! MarkDetailsViewController
			dst.marker = sender as? MapMarkPoint
		}
	}
	
	@objc
	func addMark() {
		performSegue(withIdentifier: "addmark", sender: self)
	}
		
	@objc
	func handleSettingsTap(recognzier: UITapGestureRecognizer) {
		switch recognzier.state {
		case .ended:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default:
			break
		}
	}
	
	@objc
	func handleSettingsPan (recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			startInteractiveTransition(state: nextState, duration: 0.9)
			
		case .changed:
			let translation = recognizer.translation(in: self.settingsViewController.handleArea)
			var fractionComplete = translation.y / endSettingsHeight
			fractionComplete = settingsVisible ? fractionComplete : -fractionComplete
			updateInteractiveTransition(fractionCompleted: fractionComplete)
		case .ended:
			continueInteractiveTransition()
		default:
			break
		}
	}

	@objc
	func handleSwitch(_ sender: Any?) {
		switch sender as! UISwitch {
		case settingsViewController.switchPoints:
			if settingsViewController.switchPoints.isOn {
				self.map.addAnnotations(self.points)
			} else {
				self.map.removeAnnotations(self.points)
			}
			break
		case settingsViewController.switchMarkers:
			if settingsViewController.switchMarkers.isOn {
				self.map.addAnnotations(self.markers)
			} else {
				self.map.removeAnnotations(self.markers)
			}
			break
		case settingsViewController.switchHighest:
			if settingsViewController.switchHighest.isOn {
				self.map.addAnnotations(self.mountainsHighest100)
			} else {
				self.map.removeAnnotations(self.mountainsHighest100)
			}
			break
		case settingsViewController.switchSevenPeaks:
			if settingsViewController.switchSevenPeaks.isOn {
				self.map.addAnnotations(self.mountains7Peaks)
			} else {
				self.map.removeAnnotations(self.mountains7Peaks)
			}
			break
		case settingsViewController.switchSnowLeopard:
			if settingsViewController.switchSnowLeopard.isOn {
				self.map.addAnnotations(self.mountainsSnowLeopardRussia)
			} else {
				self.map.removeAnnotations(self.mountainsSnowLeopardRussia)
			}
			break
		default:
			break
		}
		saveSettings()
	}
}

extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		if annotation is MapPointBase {
			let point = annotation as! MapPointBase
			var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: point.identifier) as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "map")
				pinView!.pinTintColor = point.tintColor
				pinView!.animatesDrop = true
				pinView!.canShowCallout = true
				if let image = point.iconImage {
					pinView!.leftCalloutAccessoryView = UIImageView(image: image)
				}
				if annotation is MapMarkPoint {
					let details = UILabel()
					details.numberOfLines = 2
					details.text = (annotation as? MapMarkPoint)?.subtitle ?? ""
					details.textColor = .lightGray
					details.font = details.font.withSize(13)
					pinView!.detailCalloutAccessoryView = details
					let btnDetails = UIButtonWithTarget(type: UIButton.ButtonType.detailDisclosure)
					btnDetails.setTarget(annotation)
					btnDetails.addTarget(self, action: #selector(showAnnotationDetails), for: .touchUpInside)
					pinView!.rightCalloutAccessoryView = btnDetails
				}
				if annotation is MapMountainPoint {
					let details = UILabel()
					details.numberOfLines = 3
					details.text = (annotation as? MapMountainPoint)?.subtitle ?? ""
					details.textColor = .lightGray
					details.font = details.font.withSize(13)
					pinView!.detailCalloutAccessoryView = details
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
