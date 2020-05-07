//
//  MapPoint.swift
//  Geo
//
//  Created by Иван Алексеев on 16.02.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import MapKit

open class MapPoint: NSObject {
	
	internal var mDate: Date
	internal var mLatitude: Double
	internal var mLongitude: Double
	internal var mPressure: Double
	internal var mAltitudeBAR: Double
	internal var mEverest: Double
	internal var mAltitudeGPS: Double
	
	init(date: Date, latitude: Double, longitude: Double, pressure: Double,
		altitudeBAR: Double, everest: Double, altitudeGPS: Double) {
		mDate = date
		mLatitude = latitude
		mLongitude = longitude
		mPressure = pressure
		mAltitudeBAR = altitudeBAR
		mEverest = everest
		mAltitudeGPS = altitudeGPS
	}
}

extension MapPoint : MKAnnotation {
	
	//MKAnnotqation
	public var coordinate: CLLocationCoordinate2D {
		get {
			return
				CLLocationCoordinate2D(
					latitude: mLatitude,
					longitude: mLongitude)
		}
	}
	
	public var title: String? {
		get {
			let df = DateFormatter()
			df.dateStyle = .medium
			df.timeStyle = .short
			return df.string(from: mDate)
		}
	}
	
	public var subtitle: String? {
		get {
			
			let everestPercent = mEverest
			let everestPercentText = String(format: "%.4f", everestPercent)
			let h = mAltitudeBAR
			let heightText = (h > 999 ? String(format: "%.1f", h/1000.0) : String(format: "%.0f", h))
			let pressureText = String(format: "%.0f", mPressure * 7.50062)
			let heightUnitText = (h > 999 ? NSLocalizedString("km", comment: "") : NSLocalizedString("m", comment: ""))
			let pressureUnitText = NSLocalizedString("mm Hg", comment: "")
			let everestUnitText = NSLocalizedString("% 🏔", comment: "")
			
			return "\(heightText)\(heightUnitText), \(everestPercentText)\(everestUnitText), \(pressureText)\(pressureUnitText)"
		}
	}
	
}
