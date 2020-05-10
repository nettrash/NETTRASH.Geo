//
//  MarkDetailsViewController.swift
//  Geo
//
//  Created by Иван Алексеев on 07.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit

class MarkDetailsViewController : UIViewController {
	
	var marker: MapMarkPoint!
	@IBOutlet var lblTitle: UILabel!
	@IBOutlet var lblDate: UILabel!
	@IBOutlet var lblAltitudeGPS: UILabel!
	@IBOutlet var lblAltitudeBAR: UILabel!
	@IBOutlet var lblEverest: UILabel!
	@IBOutlet var lblPressureKPA: UILabel!
	@IBOutlet var lblPressureMMHG: UILabel!
	@IBOutlet var lblPressureATM: UILabel!
	@IBOutlet var lblLatitude: UILabel!
	@IBOutlet var lblLongitude: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Marker details", comment: "")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.initialize()
		self.lblTitle.text = marker.name
		self.lblDate.text = marker.dateString
		self.lblAltitudeBAR.text = String(format: NSLocalizedString("%.0fm", comment: ""), marker.altitudeBAR)
		self.lblAltitudeGPS.text = String(format: NSLocalizedString("%.0fm", comment: ""), marker.altitudeGPS)
		self.lblPressureKPA.text = String(format: NSLocalizedString("%.4f kPa", comment: ""), marker.pressure)
		self.lblPressureMMHG.text = String(format: NSLocalizedString("%.4f mm Hg", comment: ""), marker.pressure * 7.50062)
		self.lblPressureATM.text = String(format: NSLocalizedString("%.4f atm", comment: ""), marker.pressure / 101.325)
		self.lblEverest.text = String(format: "%.4f", marker.everest)
		self.lblLatitude.text = String(format: "%.6f", marker.latitude)
		self.lblLongitude.text = String(format: "%.6f", marker.longitude)
	}

	private func initialize() {
		
	}
}
