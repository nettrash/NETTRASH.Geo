//
//  MapMountainPoint.swift
//  Geo
//
//  Created by Иван Алексеев on 18.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

open class MapMountainPoint: NSObject {
	
	private var mMountain: MountainInfo
	
	init(mountain: MountainInfo) {
		mMountain = mountain
	}
}

extension MapMountainPoint : MKAnnotation {
	
	//MKAnnotqation
	public var coordinate: CLLocationCoordinate2D {
		get {
			return
				CLLocationCoordinate2D(
					latitude: (mMountain.coordinates?.latitude)!,
					longitude: (mMountain.coordinates?.longitude)!)
		}
	}
	
	public var title: String? {
		get {
			return mMountain.name
		}
	}
	
	public var subtitle: String? {
		get {
			var summitInfo = ""
			if (mMountain.firstAscent ?? "" == "") {
				summitInfo = NSLocalizedString("MountainNoSummit", comment: "")
			} else {
				summitInfo = String(format: NSLocalizedString("MountainSummit", comment: ""), mMountain.firstAscent!)
			}
			return String(format: NSLocalizedString("MountainDetails", comment: ""), mMountain.height!, summitInfo)
		}
	}
	
}
