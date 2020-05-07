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
	@IBOutlet var lblPressure: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Marker details", comment: "")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.initialize()
		self.lblTitle.text = marker.mName
		self.lblDate.text = marker.date
		self.lblAltitudeBAR.text = String(format: NSLocalizedString("%.0fm", comment: ""), marker.mAltitudeBAR)
		self.lblAltitudeGPS.text = String(format: NSLocalizedString("%.0fm", comment: ""), marker.mAltitudeGPS)
	}

	private func initialize() {
		
	}
}
