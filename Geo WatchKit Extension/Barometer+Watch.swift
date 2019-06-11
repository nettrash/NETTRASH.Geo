//
//  Barometer+Watch.swift
//  Geo WatchKit Extension
//
//  Created by Иван Алексеев on 10/06/2019.
//  Copyright © 2019 NETTRASH. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

class WatchBarometer : Barometer {
	
	override init() {
		super.init()
		Start()
	}
	
	override func Handler(_ data: CMAltitudeData?, _ error: Error?) {
		super.Handler(data, error)
		let ext: ExtensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
		ext.refreshComplication()
	}
	
}
