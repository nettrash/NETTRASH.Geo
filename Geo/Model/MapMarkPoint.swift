//
//  MapMarkPoint.swift
//  Geo
//
//  Created by Иван Алексеев on 07.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import MapKit

class MapMarkPoint : MapPoint {
	
	internal var mName: String
	internal var mMessage: String
	
	init(name: String, message: String, date: Date, latitude: Double, longitude: Double, pressure: Double,
		altitudeBAR: Double, everest: Double, altitudeGPS: Double) {
		
		mName = name
		mMessage = message

		super.init(
			date: date,
			latitude: latitude,
			longitude: longitude,
			pressure: pressure,
			altitudeBAR: altitudeBAR,
			everest: everest, altitudeGPS: altitudeGPS)
	}

	override var title: String? {
		get {
			return mName
		}
	}
	
	override var subtitle: String? {
		get {
			return "\(super.title ?? "")\n\(super.subtitle ?? "")"
		}
	}
	
	var date: String? {
		get {
			return super.title
		}
	}
}
