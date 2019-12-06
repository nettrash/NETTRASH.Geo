//
//  TodayViewController.swift
//  Today
//
//  Created by Иван Алексеев on 30.11.2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
        
	var bar: Barometer?
	var dataHandler: ((NCUpdateResult) -> Void)?
	@IBOutlet var lblInfo: UILabel!
	@IBOutlet var graphViewAltitudeBar: GraphView!
	var graphPointsAltitudeBar: [Int] = []
	var graphPointsPressure: [Int] = []
	var graphPointsEverest: [Int] = []

	static var persistentContainer: PersistentContainer = {
		let container = PersistentContainer(name: "group.ru.nettrash.geo")
		container.loadPersistentStores(completionHandler: { (storeDescription:NSPersistentStoreDescription, error:Error?) in
			if let error = error as NSError?{
				fatalError("UnResolved error \(error), \(error.userInfo)")
			}
		})
		
		return container
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		lblInfo.text = "..."
		bar = Barometer()
		bar?.dataUpdated = refreshAltitudeInfo
		bar?.Start()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		lblInfo.text = ""
        dataHandler = completionHandler
		if (!(self.bar?.available ?? false)) {
			self.lblInfo.text = NSLocalizedString("barometer not available", comment: "")
			dataHandler?(NCUpdateResult.newData)
		}
    }
	
	func refreshAltitudeInfo() {
		guard let barometer = self.bar else {
			dataHandler?(NCUpdateResult.failed)
			return
		}
		if (barometer.available) {
			let everestPercent = 100.0 * barometer.everest
			let everestPercentText = String(format: "%.4f", everestPercent)
			let h = barometer.height
			let heightText = (h > 999 ? String(format: "%.1f", h/1000.0) : String(format: "%.0f", h))
			let pressureText = String(format: "%.0f", barometer.pressure * 7.50062)
			let heightUnitText = (h > 999 ? NSLocalizedString("km", comment: "") : NSLocalizedString("m", comment: ""))
			let pressureUnitText = NSLocalizedString("mm Hg", comment: "")
			let everestUnitText = NSLocalizedString("% 🏔", comment: "")
			
			self.lblInfo.text = "\(heightText) \(heightUnitText)\n\(everestPercentText) \(everestUnitText)\n\(pressureText) \(pressureUnitText)"
		
			dataHandler?(NCUpdateResult.newData)
		} else {
			self.lblInfo.text = NSLocalizedString("barometer not available", comment: "")
			dataHandler?(NCUpdateResult.newData)
		}
	}
}
