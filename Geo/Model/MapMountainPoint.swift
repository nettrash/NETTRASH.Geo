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

enum MountainType {
	case HIGHEST
	case SEVEN_PEAKS
	case SNOW_LEOPARD_OF_RUSSIA
}

open class MapMountainPoint: MapPointBase {
	
	private var mMountainType: MountainType
	private var mTitle: String
	private var mSubtitle: String
	private var mLatitude: Double
	private var mLongitude: Double
	
	override public var identifier: String {
		get {
			return "\(mMountainType)"
		}
	}
	override public var tintColor: UIColor {
		get {
			switch mMountainType {
			case .HIGHEST:
				return .black
			case .SEVEN_PEAKS:
				return .darkGray
			case .SNOW_LEOPARD_OF_RUSSIA:
				return .white
			}
		}
	}
	override public var iconImage: UIImage? {
		get {
			switch mMountainType {
			case .HIGHEST:
				return UIImage(named: "MapMountainPoint")
			case .SEVEN_PEAKS:
				return UIImage(named: "MapMountainSevenPeaksPoint")
			case .SNOW_LEOPARD_OF_RUSSIA:
				return UIImage(named: "MapMountainSnowLeopardPoint")
			}
		}
	}

	init(mountain: MountainInfo, type mountainType: MountainType) {
		mMountainType = mountainType
		mTitle = mountain.name ?? ""
		mSubtitle = ""
		switch mMountainType {
		case .HIGHEST:
			var summitInfo = ""
			if (mountain.firstAscent ?? "" == "") {
				summitInfo = NSLocalizedString("MountainNoSummit", comment: "")
			} else {
				summitInfo = String(format: NSLocalizedString("MountainSummit", comment: ""), mountain.firstAscent!)
			}
			mSubtitle = String(format: NSLocalizedString("MountainDetails", comment: ""), mountain.height!, summitInfo)
		case .SEVEN_PEAKS:
			mSubtitle = String(format: NSLocalizedString("MountainDetails", comment: ""), mountain.height!, "(\(mountain.location ?? ""))")
		case .SNOW_LEOPARD_OF_RUSSIA:
			mSubtitle = "#\(mountain.position ?? 0) \(String(format: NSLocalizedString("MountainDetails", comment: ""), mountain.height!, "(\(mountain.location ?? ""))"))"
		}
		if let coord = mountain.coordinates {
			mLatitude = coord.latitude!
			mLongitude = coord.longitude!
		} else {
			mLatitude = 0
			mLongitude = 0
		}
	}
}

extension MapMountainPoint : MKAnnotation {
	
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
			return mTitle
		}
	}
	
	public var subtitle: String? {
		get {
			return mSubtitle
		}
	}
	
}
