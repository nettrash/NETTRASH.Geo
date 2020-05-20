//
//  MapPoint.swift
//  Geo
//
//  Created by Иван Алексеев on 16.02.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import MapKit

open class MapPoint: MapPointBase {
	
	private var mDate: Date
	private var mLatitude: Double
	private var mLongitude: Double
	private var mPressure: Double
	private var mAltitudeBAR: Double
	private var mEverest: Double
	private var mAltitudeGPS: Double
	
	override public var identifier: String {
		get {
			return "MapPointAnnotationView"
		}
	}
	override public var iconImage: UIImage? {
		get {
			return UIImage(named: "MapPoint")
		}
	}
	var date: Date {
		get {
			return mDate
		}
	}
	var latitude: Double {
		get {
			return mLatitude
		}
	}
	var longitude: Double {
		get {
			return mLongitude
		}
	}
	var pressure: Double {
		get {
			return mPressure
		}
	}
	var altitudeBAR: Double {
		get {
			return mAltitudeBAR
		}
	}
	var altitudeGPS: Double {
		get {
			return mAltitudeGPS
		}
	}
	var everest: Double {
		get {
			return mEverest
		}
	}
	
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
